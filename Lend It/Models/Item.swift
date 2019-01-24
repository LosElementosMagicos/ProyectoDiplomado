//
//  User.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 12/25/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseStorage

struct Item {
    
    let ownerId: String
    let borrowingUserId: String
    let itemName: String
    let latitude: Double
    let longitude: Double
    let type: String
    let price: Int
    let itemPhoto1: String
    let itemPhoto2: String
    let itemPhoto3: String
    
    init(ownerId: String, borrowingUserId: String, itemName: String, latitude: Double, longitude: Double, type: String, price: Int, itemPhoto1: String, itemPhoto2: String, itemPhoto3: String) {
        self.ownerId = ownerId
        self.borrowingUserId = borrowingUserId
        self.itemName = itemName
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.price = price
        self.itemPhoto1 = itemPhoto1
        self.itemPhoto2 = itemPhoto2
        self.itemPhoto3 = itemPhoto3
    }
    
    // Func to conver model for easier writing to database
    func toAnyObject() -> Any {
        return [
            "itemName": itemName,
            "lat": latitude,
            "lon": longitude,
            "price": price,
            "type": type,
            "itemPhoto1": itemPhoto1,
            "itemPhoto2": itemPhoto2,
            "itemPhoto3": itemPhoto3,
            "ownerId": ownerId,
            "borrowingUserId": borrowingUserId
        ]
    }
    
    func downloadImage(from storageImagePath: String, completion: @escaping (_ image: UIImage, _ path: String) -> Void) {
        let storageRef = Storage.storage().reference()
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = docDir.appendingPathComponent(String(storageImagePath.suffix(16)))
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
                        // Return the image
                        print("file saved")
                        completion(UIImage(contentsOfFile: imagePath)!, storageImagePath)
                    }
                })
            }
        }
    }
    
    func downloadAllImages(from storagePaths: [String], completion: @escaping (_ images: [UIImage]) -> Void) {
        var downloadCounter = 0
        var downloadedImages = [UIImage]()
        let storageRef = Storage.storage().reference()
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for storagePath in storagePaths {
            let imageURL = docDir.appendingPathComponent(String(storagePath.suffix(16)))
            if !FileManager.default.fileExists(atPath: imageURL.path) {
                do {
                    // Writes the image data to disk
                    // Start download of image and write it to the file url
                    let _: StorageDownloadTask = storageRef.child(storagePath).write(toFile: imageURL, completion: { (url, error) in
                        // Check for error
                        if let error = error {
                            print("Error downloading:\(error)")
                            return
                            // Get the url path of the image
                        } else if let imagePath = url?.path {
                            // Return the image
                            print("file saved")
                            downloadCounter += 1
                            downloadedImages.append(UIImage(contentsOfFile: imagePath)!)
                            if downloadCounter == storagePaths.count {
                                completion(downloadedImages)
                            }
                        }
                    })
                }
            } else {
                print("file already exists")
                downloadCounter += 1
                downloadedImages.append(UIImage(contentsOfFile: imageURL.path)!)
            }
        }
    }
}

extension Item: Equatable {}

func ==(lhs: Item, rhs: Item) -> Bool {
    let areEqual = lhs.ownerId == rhs.ownerId &&
        lhs.itemName == rhs.itemName
    return areEqual
}
