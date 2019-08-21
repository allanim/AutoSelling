//
//  AutoCommentsViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-21.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase

class AutoCommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comments: [Comment] = []
    var sourceVehicleId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // get comments
        let commentRef = Database.database().reference(withPath: "comment")
        commentRef.child(sourceVehicleId!)
            .queryOrderedByKey()
            .observe(.value, with: { snapshot in
                for child in snapshot.children {
                    if let comment = Comment(snapshot: child as! DataSnapshot) {
                        self.comments.append(comment)
                    }
                }
                self.comments.reverse()
                self.tableView.reloadData()
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddCommentViewController {
            dest.sourceVehicleId = sourceVehicleId
        } else if let dest = segue.destination as? AutoDetailsViewController {
            dest.sourceVehicleId = sourceVehicleId
        }
    }
}


// Table View
extension AutoCommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autosItem", for: indexPath)
        let comment = comments[indexPath.row]
        
        // set title & detail
        cell.textLabel?.text = comment.author
        cell.detailTextLabel?.text = comment.comment
        
        return cell
    }
}
