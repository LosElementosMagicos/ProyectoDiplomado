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
                    if UserDefaults.standard.object(forKey: "searchRadius") == nil {
                        UserDefaults.standard.set(10, forKey: "searchRadius") // in km
                    }
                    
                    // FIREBASE
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        // Save User to firebase
                        if let newUserId = Auth.auth().currentUser?.uid {
                            self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                                if snapshot.hasChild(newUserId) {
                                    // Returns if user is already saved
                                    return
                                } else {
                                    // Saves new user
                                    let newUser = User(userID: newUserId,
                                                       userName: self.name,
                                                       email: self.email,
                                                       phoneNumber: "",
                                                       isVerified: false,
                                                       profilePhoto: "")
                                    // Access the "users" child reference and then create a unique child reference within it and finally set its value
                                    self.ref.child("users").child(newUserId).setValue(newUser.toAnyObject())
                                }
                            })
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
}
