//
//  MapViewController.swift
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FirebaseStorage

class MapViewController: UIViewController, UISearchBarDelegate {
    
    var nearbyPlaces = [Item]()
    // Firebase storage
    var storageRef: StorageReference!
    var storageDownloadTask: StorageDownloadTask!
    @IBOutlet weak var hamburgerTrailingC: NSLayoutConstraint!
    @IBOutlet weak var hamburgerLeadingC: NSLayoutConstraint!
    @IBOutlet weak var hamburgerView: UIView!
    var hamburgerMenuIsVisible = false
    @IBOutlet weak var searchBar: UISearchBar!
    //private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    //private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    // User profile
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileRepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        storageRef = Storage.storage().reference()
        // Place users name
        profileNameLabel.text = UserDefaults.standard.string(forKey: "userName")
        // Hides hamburger menu
        hamburgerLeadingC.constant = -400
        hamburgerTrailingC.constant = -400
        // Prepares location
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Makes profile view circular
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        // Makes Navigation Bar invisible
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hides Keyboard
        searchBar.endEditing(true)
        // Loads nearby markers
        retrieveData(searchBarWord: searchBar.text ?? "") { (message) in
            print(message)
            if self.nearbyPlaces.isEmpty {
                let alert = UIAlertController(title: "No se encontraron coincidencias", message: "Prueba con una palabra clave.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print(self.nearbyPlaces)
            self.fetchNearbyPlaces()
        }
    }
    
    func retrieveData(searchBarWord: String, completion: @escaping (_ message: String) -> Void) {
        print("retrieving data")
        nearbyPlaces.removeAll()
        let ref = Database.database().reference(withPath: "items")
        //let userID = Auth.auth().currentUser?.uid
        var items = [Item]()
        let myLon = self.mapView.camera.target.longitude
        let myLat = self.mapView.camera.target.latitude

        ref.queryOrdered(byChild: "lon").queryStarting(atValue: myLon-0.02).queryEnding(atValue: myLon+0.02).observeSingleEvent(of: .value, with: { (snapshot)
            in
            // Firebase can only do one filer at a time so next filter (lat) must be in code
            // Returns spots who match longitude with user
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                print("im in a child")
                // Get user value
                let value = snapshot.value as? NSDictionary
                // Second filter to check if latitude is also in range
                let lat = value?["lat"] as? Double ?? 0
                if !(lat<myLat+0.02 && lat>myLat-0.02) { continue }
                // Third filter to check if name matches with search
                let itemName = value?["itemName"] as? String ?? ""
                if !(itemName.lowercased().contains(searchBarWord.lowercased())) { continue }
                // Continues to create item object
                let lon = value?["lon"] as? Double ?? 0
                let ownerId = value?["ownerId"] as? String ?? ""
                let borrowingUserId = value?["borrowingUserId"] as? String ?? ""
                let price = value?["price"] as? Int ?? 0
                let type = value?["type"] as? String ?? ""
                let itemImagePath1 = value?["itemPhoto1"] as? String ?? ""
                let itemImagePath2 = value?["itemPhoto2"] as? String ?? ""
                let itemImagePath3 = value?["itemPhoto3"] as? String ?? ""
                // Creates nearby object
                let fetchedItem = Item(ownerId: ownerId,
                                       borrowingUserId: borrowingUserId,
                                       itemName: itemName,
                                       latitude: lat,
                                       longitude: lon,
                                       type: type,
                                       price: price,
                                       itemPhoto1: itemImagePath1,
                                       itemPhoto2: itemImagePath2,
                                       itemPhoto3: itemImagePath3)
                items.append(fetchedItem)
                self.nearbyPlaces = items
            }
            // Its done here
            completion("DONE")
        }) { (error) in
        print(error.localizedDescription)
        }
    }
    
    private func fetchNearbyPlaces() {
        mapView.clear()
        for place in nearbyPlaces {
            let marker = PlaceMarker(place: place)
            marker.map = self.mapView
        }
    }
    
    func handleHamburgerMenu() {
        if !hamburgerMenuIsVisible {
            hamburgerLeadingC.constant = 0
            hamburgerTrailingC.constant = -60
            hamburgerMenuIsVisible = true
            mapView.isUserInteractionEnabled = false
            searchBar.isUserInteractionEnabled = false
            searchBar.endEditing(true)
            self.navigationController?.navigationBar.isHidden = true
        } else {
            //if the hamburger menu IS visible, then move the ubeView back to its original position
            hamburgerLeadingC.constant = -400
            hamburgerTrailingC.constant = -400
            hamburgerMenuIsVisible = false
            mapView.isUserInteractionEnabled = true
            searchBar.isUserInteractionEnabled = true
            self.navigationController?.navigationBar.isHidden = false
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }
  
    @IBAction func hamburgerButtonTapped(_ sender: Any) {
        handleHamburgerMenu()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        // Exits hamburger menu
        if touch.view != hamburgerView && hamburgerMenuIsVisible {
            handleHamburgerMenu()
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error
        in
        guard let address = response?.firstResult(), let lines = address.lines else {
            return
        }
        self.addressLabel.unlock()
        self.addressLabel.text = lines.joined(separator: "\n")
        let labelHeight = self.addressLabel.intrinsicContentSize.height
        self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: labelHeight, right: 0)
        UIView.animate(withDuration: 0.25) {
            self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
            self.view.layoutIfNeeded()
            }
        }
    }

  /*
  // MARK: - Pass Data
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navigationController = segue.destination as? UINavigationController,
      let controller = navigationController.topViewController as? TypesTableViewController else {
        return
    }
    controller.selectedTypes = searchedTypes
    controller.delegate = self
  }
 */
    @IBAction func exitButtonTapped(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        performSegue(withIdentifier: "unwindToSignInSegue", sender: self)
    }
    
    func downloadImage(from storageImagePath: String, completion: @escaping (_ image: UIImage) -> Void) {
        // 1. Get a filePath to save the image at
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        // 2. Get the url of that file path
        guard let fileURL = URL(string: filePath) else { return }
        
        // 3. Start download of image and write it to the file url
        storageDownloadTask = storageRef.child(storageImagePath).write(toFile: fileURL, completion: { (url, error) in
            // 4. Check for error
            if let error = error {
                print("Error downloading:\(error)")
                return
                // 5. Get the url path of the image
            } else if let imagePath = url?.path {
                // 6. Return the image
                completion(UIImage(contentsOfFile: imagePath)!)
            }
        })
        // 7. Finish download of image
        //return
    }

}




// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }
    locationManager.startUpdatingLocation()
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    locationManager.stopUpdatingLocation()
  }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocodeCoordinate(position.target)
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    addressLabel.lock()
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
    
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    searchBar.endEditing(true)
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    guard let placeMarker = marker as? PlaceMarker else {
      return nil
    }
    guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
      return nil
    }
    // Place marker info
    infoView.nameLabel.text = placeMarker.place.itemName
    
    marker.tracksInfoWindowChanges = true
    let photoPath = placeMarker.place.itemPhoto1
    if let imageData = UserDefaults.standard.data(forKey: photoPath) {
        infoView.placePhoto.image = UIImage(data: imageData)
    } else {
        downloadImage(from: photoPath) { (image) in
            infoView.placePhoto.image = image
            print("finished downloading photo")
            let imageData = image.jpegData(compressionQuality: 0.1)
            UserDefaults.standard.set(imageData, forKey: photoPath)
            marker.tracksInfoWindowChanges = false
        }
    }
    searchBar.endEditing(true)
    return infoView
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
}

 
