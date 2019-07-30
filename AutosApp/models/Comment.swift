//
//  Comment.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-26.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import Firebase

struct Comment {
    let ref: DatabaseReference?
    let key: String
    
    var vehicleKey: String
    var parentKey: String
    
    var author: String
    var comment: String
    var regDate: Date
}
