//
//  User.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-24.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let displayName: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
        displayName = authData.displayName!
    }
    
    init(uid: String, email: String, displayName: String) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
    
}
