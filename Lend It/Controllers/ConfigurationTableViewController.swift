//
//  ConfigurationTableViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/27/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ConfigurationTableViewController: UITableViewController {

    // Section 1
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Section 2
    @IBOutlet weak var maxDistanceLabel: UILabel!
    @IBOutlet weak var maxDistanceSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Loads profile's cell info
        profileNameLabel.text = UserDefaults.standard.string(forKey: "userName")
        profileEmailLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        // Makes profile view circular
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        let imagePath = "profileImages/" + (Auth.auth().currentUser?.uid)! + ".jpg"
        if let image = loadImageFromDocuments(imagePath: imagePath) {
            profileImageView.image = image
        }
    }
    
    @IBAction func maxDistanceSliderValueChanged(_ sender: UISlider) {
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Profile cell
        if indexPath.section == 0 && indexPath.row == 0 {
            print("profile")
            performSegue(withIdentifier: "userProfileSegue", sender: self)
        }
        // Log Out cell
        if indexPath.section == 2 && indexPath.row == 0 {
            print("log out")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            clearAllFilesFromTempDirectory()
            let previousNC = presentingViewController as? UINavigationController
            if let previousVC = previousNC?.viewControllers.first as? MapViewController {
                self.navigationController?.dismiss(animated: false, completion: nil)
                previousVC.performSegue(withIdentifier: "unwindToSignInSegue", sender: self)
            }
        }
    }

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        // Access previous view controller to pass new image
        let previousNC = presentingViewController as? UINavigationController
        if let previousVC = previousNC?.viewControllers.first as? MapViewController {
            previousVC.profileImageView.image = profileImageView.image
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
