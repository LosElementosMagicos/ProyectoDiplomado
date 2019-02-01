//
//  HelpViewController.swift
//  Lend It
//
//  Created by Grecia Escárcega on 2/1/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var helpTextLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = helpTitle
        helpTextLabel.text = helpText
    }
}
