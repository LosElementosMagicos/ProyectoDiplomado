//
//  SaveLoadImageHelper.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/11/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

func saveImageToDocuments(image: UIImage, imagePath: String) {
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageURL = docDir.appendingPathComponent(String(imagePath.suffix(16)))
    if let imageData = image.jpegData(compressionQuality: 0.1),
        !FileManager.default.fileExists(atPath: imageURL.path) {
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
    let imageURL = docDir.appendingPathComponent(String(imagePath.suffix(16)))
    if let image = UIImage(contentsOfFile: imageURL.path) {
        print("file loaded")
        return image
    } else {
        print("error loading file")
        return nil
    }
}

func loadImageFromDocuments(imagePath: String, completion: @escaping (_ image: UIImage, _ path: String) -> Void) {
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageURL = docDir.appendingPathComponent(String(imagePath.suffix(16)))
    if let image = UIImage(contentsOfFile: imageURL.path) {
        print("file loaded")
        completion(image, imagePath)
        return
    } else {
        print("error loading file")
        return
    }
}

func clearAllFilesFromTempDirectory()
{
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            if fileURL.pathExtension == "jpg" {
                try FileManager.default.removeItem(at: fileURL)
            }
        }
    } catch  { print(error) }
}
