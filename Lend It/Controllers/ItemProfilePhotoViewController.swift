//
//  ItemProfilePhotoViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/10/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ItemProfilePhotoViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    var dataObject = UIImage(named: "add-camera.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImageView.image = dataObject
    }

}
