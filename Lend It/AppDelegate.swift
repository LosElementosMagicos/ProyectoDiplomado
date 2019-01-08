//
//  AppDelegate.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 12/24/18.
//  Copyright © 2018 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

let googleApiKey = "AIzaSyD3s0MravuM-ndRDWlwpMLijPX_HWskxH0"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Add any custom logic here.
        GMSServices.provideAPIKey(googleApiKey)
        FirebaseApp.configure()
        return true
    }
    
    //Facebook Login
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if ((FBSDKAccessToken.current()) != nil) {
            print("User is logged in")
            self.window?.rootViewController?.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
        } else {
            print("User is not logged")
        }
    }
}

