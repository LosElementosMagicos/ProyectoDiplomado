//
//  AddItemViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/5/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemPriceTextField: CurrencyField!
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var photoButton1: UIButton!
    @IBOutlet weak var photoButton2: UIButton!
    @IBOutlet weak var photoButton3: UIButton!
    var imagePaths: [String?] = [nil,nil,nil]
    // Helps handlinh NetworkActivityIndicator
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible =              showNetworkActivityIndicator
        }
    }
    // References for storaging images and database
    fileprivate var ref: DatabaseReference!
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!

    override func viewDidLoad() {
        super.viewDidLoad()
        itemTitleTextField.delegate = self
        // Update price label to show currency
        itemPriceTextField.editingChanged()
        // Place keyboard notifications to adjust scroll view
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        // Gesture to hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:))))
        // Reference used to upload photos
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Set max lenght for text fields.
        let maxLength = 30
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func addNewImageButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sender.tag = 1 // Helps identify which button was tapped
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        // 1. Get image data from selected image
        guard
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.1) else {
                print("Could not get Image JPEG Representation")
                return
        }
        dismiss(animated: true, completion: nil)
        // Set image to the selected button
        let buttons = [photoButton1,photoButton2,photoButton3]
        for (index,button) in buttons.enumerated() {
            if button?.tag == 1 {
                button?.setImage(image, for: .normal)
                button?.tag = 0
                // 2. Create a unique image path for image. In the case I am using the googleAppId of my account appended to the interval between 00:00:00 UTC on 1 January 2001 and the current date and time as an Integer and then I append .jpg. You can use whatever you prefer as long as it ends up unique.
                let imagePath = Auth.auth().app!.options.googleAppID + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                imagePaths[index] = imagePath
                // 3. Set up metadata with appropriate content type
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                // 4. Show activity indicator
                showNetworkActivityIndicator = true
                // 5. Start upload task
                storageUploadTask = storageRef.child(imagePath).putData(imageData, metadata: metadata) { (_, error) in
                    // 6. Hide activity indicator because uploading is done with or without an error
                    self.showNetworkActivityIndicator = false
                    
                    guard error == nil else {
                        print("Error uploading: \(error!)")
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func publishNewItemButtonPressed(_ sender: Any) {
        writeNewItemToDatabase()
    }
    
    fileprivate func writeNewItemToDatabase() {
        guard
            let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude,
            let ownerId = Auth.auth().currentUser?.uid,
            let itemName = itemTitleTextField.text,
            let itemImagePath1 = imagePaths[0],
            let itemImagePath2 = imagePaths[1],
            let itemImagePath3 = imagePaths[2]
            else {
                // Missing fields, present alert
                let alert = UIAlertController(title: "Hay campos vacíos", message: "Por favor llena todos los campos.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        let price = itemPriceTextField.integerValue
        let borrowingUserId = ""
        let type = "Tool"
        let newItem = Item(ownerId: ownerId,
                               borrowingUserId: borrowingUserId,
                               itemName: itemName,
                               latitude: latitude,
                               longitude: longitude,
                               type: type,
                               price: price,
                               itemPhoto1: itemImagePath1,
                               itemPhoto2: itemImagePath2,
                               itemPhoto3: itemImagePath3)
        // Access the "items" child reference and then create a unique child reference within it and finally set its value
        ref.child("items").child("\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(newItem.toAnyObject())
        let alert  = UIAlertController(title: "Subida Exitosa!", message: "Tu objeto se encuentra listo para ser rentado!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
}

// Corrects bug cropping an offset on images related to not hidding statusbar
extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}





