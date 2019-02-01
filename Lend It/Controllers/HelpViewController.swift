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
    @IBOutlet weak var helpTextView: UITextView!
    var helpTitle = ""
    var helpText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = helpTitle
        helpTextView.text = helpText
        // helpTextView starting at top and not bottom
        helpTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
