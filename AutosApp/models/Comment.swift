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
    
    var author: String
    var comment: String

    init(author: String, comment: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.author = author
        self.comment = comment
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let author = value["author"] as? String,
            let comment = value["comment"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.author = author
        self.comment = comment
    }
    
    func toAnyObject() -> Any {
        return [
            "author": author,
            "comment": comment
        ]
    }
}
