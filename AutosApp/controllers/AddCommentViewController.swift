//
//  AddCommentViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-21.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase

class AddCommentViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtComment: UITextField!
    
    var sourceVehicleId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check auth
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                let userInfoRef = Database.database().reference(withPath: "user-info")
                userInfoRef.child(user!.uid).observe(.value, with: { snapshot in
                    let userInfo = UserInfo(snapshot: snapshot);
                    self.txtName.text = userInfo!.fullName
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AutoCommentsViewController {
            dest.sourceVehicleId = sourceVehicleId
        }
    }
    
    @IBAction func BtnAddClick(_ sender: Any) {
        
        guard
            let name = txtName.text,
            let comment = txtComment.text,
            name.count > 0,
            comment.count > 0
            else {
                return
        }
        
        // make key from date
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
        let key = format.string(from: Date())
        
        // save comment
        let commentRef = Database.database().reference(withPath: "comment")
        let addComment = Comment(author: name, comment: comment)
        let initComment = commentRef.child(sourceVehicleId!).child(key)
        initComment.setValue(addComment.toAnyObject())
        
        // move
        self.performSegue(withIdentifier: "backComment", sender: nil)
    }
    
}
