//
//  PhoneVerificationViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/28/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import AccountKit

class PhoneVerificationViewController: UIViewController {

    //MARK: - Variabes
    var _accountKit: AKFAccountKit!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize Account Kit
        if _accountKit == nil {
            print("Account is nil")
            _accountKit = AKFAccountKit(responseType: .accessToken)
            phoneVerificationWithPhone()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
            
        }
        else{
            // Show the login screen
            print("Not logged in")
            
        }
    }
    
    //MARK: - Helper Methods
    
    func preparePhoneVerificationViewController(phoneVerificationViewController: AKFViewController) {
        phoneVerificationViewController.delegate = self
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        phoneVerificationViewController.setTheme(theme)
    }
    
    //Login with phone number
    func phoneVerificationWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.preparePhoneVerificationViewController(phoneVerificationViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func btnLoginWithPhoneOnClick(_ sender: UIButton) {
        self.phoneVerificationWithPhone()
    }
    
}

extension PhoneVerificationViewController: AKFViewControllerDelegate {
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(String(describing: state))")
    }
    
    // handle callback on successful login to show authorization code
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("didCompleteLoginWithAuthorizationCode")
    }
    
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
    }

}
