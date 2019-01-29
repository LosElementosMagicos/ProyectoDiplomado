//
//  PhoneVerificationViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/28/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import AccountKit
import FirebaseAuth
import FirebaseDatabase

class PhoneVerificationViewController: UIViewController {

    var accountKit: AKFAccountKit!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize Account Kit
        if accountKit == nil {
            accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
        }
        else{
            // Show the login screen
            print("Not logged in")
            
        }
    }
    
    //MARK: - Helper Methods
    
    func preparePhoneVerificationVC(phoneVerificationViewController: AKFViewController) {
        phoneVerificationViewController.delegate = self
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerTextType = .appName
        theme.headerBackgroundColor = UIColor.black
        theme.headerTextColor = UIColor.white
        theme.iconColor = UIColor.black
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .lightContent
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        phoneVerificationViewController.setTheme(theme)
    }
    
    //Login with phone number
    func phoneVerification(){
        let inputState = UUID().uuidString
        let vc = (accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.preparePhoneVerificationVC(phoneVerificationViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
}

extension PhoneVerificationViewController: AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
        print("viewControllerDidCancel")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(String(describing: viewController)) did fail with error: \(error.localizedDescription)")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("didCompleteLoginWith")
        accountKit.requestAccount { (account, error) in
            if(error != nil){
                //error while fetching information
            } else {
                if let phoneNum = account?.phoneNumber{
                    // Store new number in Firebase
                    let userId = Auth.auth().currentUser?.uid
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("users/\(userId!)/phoneNumber").setValue(phoneNum.stringRepresentation())
                    ref.child("users/\(userId!)/isVerified").setValue(true)
                }
            }
        }
    }

}
