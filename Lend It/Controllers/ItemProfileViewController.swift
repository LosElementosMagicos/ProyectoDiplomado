//
//  ItemProfileViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/10/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ItemProfileViewController: UIViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemReviewsButton: UIButton!
    @IBOutlet weak var paymentMethodButton: UIButton!
    
    var item: Item = Item(ownerId: "",
                          borrowingUserId: "",
                          itemName: "",
                          latitude: 0,
                          longitude: 0,
                          type: "",
                          price: 0,
                          itemPhoto1: "",
                          itemPhoto2: "",
                          itemPhoto3: "")
    var photoData: [UIImage] = [UIImage(named: "add-camera.png")!,
                                UIImage(named: "add-camera.png")!,
                                UIImage(named: "add-camera.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign item properties to labels and buttons
        let formattedPrice = Formatter.currency.string(from: NSDecimalNumber(integerLiteral: item.price))
        itemPriceLabel.text = formattedPrice
        itemNameLabel.text = item.itemName
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PhotoPageVCSegue") {
            let childViewController = segue.destination as! ItemProfilePageViewController
            childViewController.photoData[0] = self.photoData[0]
            childViewController.photoData[1] = self.photoData[1]
            childViewController.photoData[2] = self.photoData[2]
        }
        
    }

}
