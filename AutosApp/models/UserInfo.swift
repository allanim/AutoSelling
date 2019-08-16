//
//  UserInfo.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-24.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import Firebase

struct UserInfo {
    
    let ref: DatabaseReference?
    let key: String
    
    let email: String
    let firstName: String
    let lastName: String
    
    var fullName: String {
        get {
            return firstName + " " + lastName
        }
    }
    
    init(email: String, firstName: String, lastName: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let firstName = value["firstName"] as? String,
            let lastName = value["lastName"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
    }
}
