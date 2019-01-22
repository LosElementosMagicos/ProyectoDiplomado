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
    
    @IBOutlet weak var lendButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    var nearbyPlaces = [Item]()
    // Firebase storage
    /*
    var storageRef: StorageReference!
    var storageDownloadTask: StorageDownloadTask!*/
    @IBOutlet weak var hamburgerTrailingC: NSLayoutConstraint!
    @IBOutlet weak var hamburgerLeadingC: NSLayoutConstraint!
    @IBOutlet weak var hamburgerView: UIView!
    var hamburgerMenuIsVisible = false
    @IBOutlet weak var searchBar: UISearchBar!
    //private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var markerNearbyItemIndex = 0
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
        rentButton.isHidden = true
        searchBar.delegate = self
        //storageRef = Storage.storage().reference()
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
    /*
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
    */
    func swapLendRentButtons() {
        lendButton.isHidden = !lendButton.isHidden
        rentButton.isHidden = !rentButton.isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RentItSegue" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.viewControllers.first as! ItemProfileViewController
            let selectedItem = nearbyPlaces[markerNearbyItemIndex]
            vc.item = selectedItem
            vc.photoData[0] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto1)!
            vc.photoData[1] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto2)!
            vc.photoData[2] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto3)!
        }
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
  
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        swapLendRentButtons()
    }
    
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    guard let placeMarker = marker as? PlaceMarker else {
      return nil
    }
    guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
      return nil
    }
    // Keeps track of wich marker in array was touched
    markerNearbyItemIndex = nearbyPlaces.index(of: placeMarker.place) ?? 0
    
    // Place marker info
    infoView.nameLabel.text = placeMarker.place.itemName
    // Format price to currency
    let formattedPrice = Formatter.currency.string(from: NSDecimalNumber(integerLiteral: placeMarker.place.price))
    infoView.priceLabel.text = formattedPrice
    // Make image circular
    infoView.placePhoto.layer.cornerRadius = infoView.placePhoto.frame.width / 2
    infoView.placePhoto.clipsToBounds = true
    marker.tracksInfoWindowChanges = true
    var photoPaths: [String] = ["","",""]
    photoPaths[0] = placeMarker.place.itemPhoto1
    photoPaths[1] = placeMarker.place.itemPhoto2
    photoPaths[2] = placeMarker.place.itemPhoto3
    if let loadedImage1 = loadImageFromDocuments(imagePath: photoPaths[0]),
        let loadedImage2 = loadImageFromDocuments(imagePath: photoPaths[1]),
        let loadedImage3 = loadImageFromDocuments(imagePath: photoPaths[2]) {
        infoView.placePhoto.animationImages = [loadedImage1,loadedImage2,loadedImage3]
        infoView.placePhoto.animationDuration = 6.0
        infoView.placePhoto.animationRepeatCount = 0
        infoView.placePhoto.startAnimating()
    } else {
        placeMarker.place.downloadImage(from: photoPaths[0]) { (image) in
            infoView.placePhoto.image = image
            print("finished downloading photo")
            saveImageToDocuments(image: image, imagePath: photoPaths[0])
            marker.tracksInfoWindowChanges = false
        }
        placeMarker.place.downloadImage(from: photoPaths[1]) { (image) in
            saveImageToDocuments(image: image, imagePath: photoPaths[1])
        }
        placeMarker.place.downloadImage(from: photoPaths[2]) { (image) in
            saveImageToDocuments(image: image, imagePath: photoPaths[2])
        }
    }
    searchBar.endEditing(true)
    return infoView
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    // Change lend rent buttons
    swapLendRentButtons()
    return false
  }
  
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
}

 
