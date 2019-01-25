//
//  MyRentedItemsTableViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/25/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import Firebase

class MyRentedItemsTableViewController: UITableViewController {
    var items = [Item]()
    var itemImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch items and when finished, download their first image
        fetchMyItems { fetchedItems in
            self.items = fetchedItems
            self.tableView.reloadData()
            for item in fetchedItems {
                item.downloadImage(from: item.itemPhoto1, completion: { (image, path) in
                    self.itemImages.append(image)
                    if self.items.count == self.itemImages.count {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MyItemsTableViewCell", owner: self, options: nil)?.first as! MyItemsTableViewCell
        cell.tag = indexPath.row
        let item = items[indexPath.row]
        if cell.tag == indexPath.row {
            cell.itemImage.alpha = 0
            if let image = loadImageFromDocuments(imagePath: item.itemPhoto1) {
                itemImages.append(image)
                cell.itemImage.image = image
            }
            cell.itemImage.fadeIn(2.0)
        }
        cell.itemName.text = item.itemName
        let formattedPrice = Formatter.currency.string(from: NSDecimalNumber(integerLiteral: item.price))
        cell.itemPrice.text = formattedPrice
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = Bundle.main.loadNibNamed("MyItemsTableViewCell", owner: self, options: nil)?.first as! MyItemsTableViewCell
        return cell.frame.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When a row is selected, if needed, downloads and saves rest of images to documents, to be able to pass then to next view controller
        let item = items[indexPath.row]
        let paths: [String] = [item.itemPhoto1, item.itemPhoto2, item.itemPhoto3]
        if loadAllImagesFromDocuments(imagePaths: paths).count == paths.count {
            self.performSegue(withIdentifier: "itemProfileSegue", sender: indexPath.row)
        } else {
            item.downloadAllImages(from: paths) { (images) in
                self.performSegue(withIdentifier: "itemProfileSegue", sender: indexPath.row)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemProfileSegue" {
            let index = sender as! Int
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.viewControllers.first as! ItemProfileViewController
            let selectedItem = items[index]
            vc.item = selectedItem
            vc.photoData[0] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto1)!
            vc.photoData[1] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto2)!
            vc.photoData[2] = loadImageFromDocuments(imagePath: selectedItem.itemPhoto3)!
        }
    }
    
    func fetchMyItems(completion: @escaping (_ items: [Item]) -> Void) {
        let ref = Database.database().reference(withPath: "items")
        let userID = Auth.auth().currentUser?.uid
        var fetchedItems = [Item]()
        
        ref.queryOrdered(byChild: "borrowingUserId").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot)
            in
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot else { continue }
                let value = snapshot.value as? NSDictionary
                let lat = value?["lat"] as? Double ?? 0
                let itemName = value?["itemName"] as? String ?? ""
                let lon = value?["lon"] as? Double ?? 0
                let ownerId = value?["ownerId"] as? String ?? ""
                let borrowingUserId = value?["borrowingUserId"] as? String ?? ""
                let price = value?["price"] as? Int ?? 0
                let type = value?["type"] as? String ?? ""
                let itemImagePath1 = value?["itemPhoto1"] as? String ?? ""
                let itemImagePath2 = value?["itemPhoto2"] as? String ?? ""
                let itemImagePath3 = value?["itemPhoto3"] as? String ?? ""
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
                fetchedItems.append(fetchedItem)
            }
            completion(fetchedItems)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
