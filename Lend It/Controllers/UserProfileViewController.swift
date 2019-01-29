//
//  UserProfileViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/3/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class UserProfileViewController: PhoneVerificationViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneVerifiedLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneVerificationButton: UIButton!
    var ref: DatabaseReference!
    // References for storaging image
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!
    var imagePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Loads phone and verification
        ref = Database.database().reference()
        loadPhoneNumber()
        loadVerification()
        // Reference used to upload photos
        storageRef = Storage.storage().reference()
        // Makes profile view circular
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        nameLabel.text = UserDefaults.standard.string(forKey: "userName")
        emailLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        // Unique image path for user.
        imagePath = "profileImages/" + (Auth.auth().currentUser?.uid)! + ".jpg"
        if let image = loadImageFromDocuments(imagePath: imagePath) {
            profileImageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Gives time for Database to update
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.loadVerification()
            self.loadPhoneNumber()
        })
    }
    
    func loadVerification() {
        let userId = Auth.auth().currentUser?.uid
        ref.child("users/\(userId!)/isVerified").observeSingleEvent(of: .value) {
            (snapshot) in
            if let isVerified = snapshot.value as? Bool {
                self.updateVerificationUI(to: isVerified)
            }
        }
    }
    
    func loadPhoneNumber() {
        let userId = Auth.auth().currentUser?.uid
        ref.child("users/\(userId!)/phoneNumber").observeSingleEvent(of: .value) {
            (snapshot) in
            if let phoneNumber = snapshot.value as? String {
                self.phoneNumberLabel.text = phoneNumber
            }
        }
    }
    
    func updateVerificationUI(to isVerified: Bool) {
        print("heeer \(isVerified)")
        if isVerified {
            phoneVerifiedLabel.text = "✅"
            phoneVerificationButton.setTitle("verificado", for: .normal)
            phoneVerificationButton.setTitleColor(UIColor.green, for: .normal)
        } else {
            phoneVerifiedLabel.text = "❌"
            phoneVerificationButton.setTitle("sin verificar", for: .normal)
            phoneVerificationButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // Access previous view controller to pass new image
        let previousNC = presentingViewController as? UINavigationController
        if let previousVC = previousNC?.viewControllers.first as? MapViewController {
            previousVC.profileImageView.image = profileImageView.image
        }
        if let previousVC = previousNC?.viewControllers.first as? ConfigurationTableViewController {
            previousVC.profileImageView.image = profileImageView.image
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImageTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func verifyPhoneNumberTapped(_ sender: Any) {
        phoneVerification()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        // Get image data from selected image
        guard
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.1) else {
                print("Could not get Image JPEG Representation")
                return
        }
        dismiss(animated: true, completion: nil)
        // Set image to the image view
        profileImageView.image = image
        // Save image to documents
        saveImageToDocuments(image: image, imagePath: imagePath)
        // Set up metadata with appropriate content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Start upload task
        storageUploadTask = storageRef.child(imagePath).putData(imageData, metadata: metadata) { (_, error) in
            guard error == nil else {
                print("Error uploading: \(error!)")
                return
            }
        }
    }

}
