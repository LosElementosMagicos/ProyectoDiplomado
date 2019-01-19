//
//  MyItemsTableViewController.swift
//  Lend It
//
//  Created by Grecia Escárcega on 1/17/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import Firebase

class MyItemsTableViewController: UITableViewController {
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyItems()
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
        cell.itemName.text = items[indexPath.row].itemName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = Bundle.main.loadNibNamed("MyItemsTableViewCell", owner: self, options: nil)?.first as! MyItemsTableViewCell
        return cell.frame.height
    }
    
    func fetchMyItems() {
        let ref = Database.database().reference(withPath: "items")
        let userID = Auth.auth().currentUser?.uid
        
        ref.queryOrdered(byChild: "ownerId").queryEqual(toValue: userID).observeSingleEvent(of: .value, with: { (snapshot)
            in
            print(snapshot.value)
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
                self.items.append(fetchedItem)
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
}
