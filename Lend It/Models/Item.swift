//
//  User.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 12/25/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import CoreLocation
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
    
    func downloadImage(from storageImagePath: String, completion: @escaping (_ image: UIImage) -> Void) {
        let storageRef = Storage.storage().reference()
        //let storageDownloadTask: StorageDownloadTask!
        // 1. Get a filePath to save the image at
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        // 2. Get the url of that file path
        guard let fileURL = URL(string: filePath) else { return }
        
        // 3. Start download of image and write it to the file url
        let _: StorageDownloadTask = storageRef.child(storageImagePath).write(toFile: fileURL, completion: { (url, error) in
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

extension Item: Equatable {}


func ==(lhs: Item, rhs: Item) -> Bool {
    let areEqual = lhs.ownerId == rhs.ownerId &&
        lhs.itemName == rhs.itemName
    
    return areEqual
}
