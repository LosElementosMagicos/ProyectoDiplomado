//
//  SignInViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 12/25/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class SignInViewController: UIViewController {
    
    //Facebook Login Related
    var userResults:[String:AnyObject] = [:]
    var email:String = ""
    var name:String = ""
    var userImage = UIImage(named: "")
    var facebookID:String = ""
    //END
    
    // Reference for storaging 
    fileprivate var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    //MARK:- Facebook Login
    @IBAction func facebookLoginButtonClick(_ sender: UIButton) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                if fbLoginResult.grantedPermissions != nil {
                    if(fbLoginResult.grantedPermissions.contains("email")){
                        self.facebookLogin()
                    }
                }
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func facebookLogin() {
        if((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email "]).start(completionHandler: { (connection, result, error) in
                if result == nil {
                    print(error?.localizedDescription ?? "")
                }
                else{
                    self.userResults = result as! [String : AnyObject]
                    self.email = (self.userResults["email"] as? String) ?? ""
                    self.facebookID = (self.userResults["id"] as? String) ?? ""
                    self.name = (self.userResults["name"] as? String) ?? ""
                    // Save user basic data
                    UserDefaults.standard.set(self.name, forKey: "userName")
                    UserDefaults.standard.set(self.email, forKey: "userEmail")
                    
                    // FIREBASE
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        // User is signed in with firebase
                        self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    

    // MARK: - Navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoggedInSegue" && facebookID != "" {
            guard let navigationController = segue.destination as? UINavigationController,
                let controller = navigationController.topViewController as? MapViewController else {
                    return
            }
            let user = User(name: name, email: email, facebookID: facebookID)
            print(user)
            controller.user = user
        }
    }
    */
}
