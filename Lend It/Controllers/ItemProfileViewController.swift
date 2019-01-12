//
//  ItemProfileViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/10/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ItemProfileViewController: UIViewController {

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
                                UIImage(named: "icon_item.png")!,
                                UIImage(named: "icon_me.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Im prep func")
        if (segue.identifier == "PhotoPageVCSegue") {
            let childViewController = segue.destination as! ItemProfilePageViewController
            childViewController.photoData[0] = self.photoData[0]
            childViewController.photoData[1] = self.photoData[1]
            childViewController.photoData[2] = self.photoData[2]
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
