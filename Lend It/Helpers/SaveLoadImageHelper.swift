//
//  SaveLoadImageHelper.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/11/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseStorage

func saveImageToDocuments(image: UIImage, imagePath: String) {
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageURL = docDir.appendingPathComponent(String(imagePath))
    if let imageData = image.jpegData(compressionQuality: 0.1) {
        do {
            // writes the image data to disk
            try imageData.write(to: imageURL)
            print("file saved")
        } catch {
            print("error saving file:", error)
        }
    }
}

func loadImageFromDocuments(imagePath: String) -> UIImage? {
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageURL = docDir.appendingPathComponent(String(imagePath))
    if let image = UIImage(contentsOfFile: imageURL.path) {
        print("file loaded")
        return image
    } else {
        print("error loading file")
        return nil
    }
}

func loadAllImagesFromDocuments(imagePaths: [String]) -> [UIImage?] {
    var images = [UIImage]()
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    for path in imagePaths {
        let imageURL = docDir.appendingPathComponent(String(path))
        if let image = UIImage(contentsOfFile: imageURL.path) {
            print("file loaded")
            images.append(image)
        } else {
            print("error loading file")
        }
    }
    return images
}

func downloadProfileImage(from storageImagePath: String, completion: @escaping (_ image: UIImage) -> Void) {
    let storageRef = Storage.storage().reference()
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageURL = docDir.appendingPathComponent(String(storageImagePath))
    if !FileManager.default.fileExists(atPath: imageURL.path) {
        do {
            // Writes the image data to disk
            // Start download of image and write it to the file url
            let _: StorageDownloadTask = storageRef.child(storageImagePath).write(toFile: imageURL, completion: { (url, error) in
                // Check for error
                if let error = error {
                    print("Error downloading:\(error)")
                    return
                    // Get the url path of the image
                } else if let imagePath = url?.path {
                    // Image saved
                    print("profile image saved")
                    print(imageURL)
                    completion(UIImage(contentsOfFile: imagePath)!)
                }
            })
        }
    } else {
        completion(UIImage(contentsOfFile: imageURL.path)!)
    }
}

func clearAllFilesFromTempDirectory()
{
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
        }
    } catch  { print(error) }
}
