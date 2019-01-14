//
//  User.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/14/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit
import FirebaseStorage

struct User {
    
    let userID: String
    let userName: String
    let email: String
    let phoneNumber: String
    let isVerified: Bool
    let profilePhoto: String
    
    init(userID: String, userName: String, email: String, phoneNumber: String, isVerified: Bool, profilePhoto: String) {
        self.userID = userID
        self.userName = userName
        self.email = email
        self.phoneNumber = phoneNumber
        self.isVerified = isVerified
        self.profilePhoto = profilePhoto
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "email": email,
            "phoneNumber": phoneNumber,
            "isVerified": isVerified,
            "profilePhoto": profilePhoto
        ]
    }
    
    
    
}
