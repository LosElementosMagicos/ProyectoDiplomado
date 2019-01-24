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

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneVerifiedLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    // References for storaging image
    fileprivate var storageRef: StorageReference!
    fileprivate var storageUploadTask: StorageUploadTask!
    var imagePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let previousNC = presentingViewController as? UINavigationController
        if let previousVC = previousNC?.viewControllers.first as? MapViewController {
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
