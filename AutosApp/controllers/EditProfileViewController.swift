//
//  EditProfileViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-16.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase
import TransitionButton

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    
    let editProfileToMyAutos = "EditProfileToMyAutos"
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    // user info
    let userInfoRef = Database.database().reference(withPath: "user-info")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check authrization
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                // set user info
                self.userInfoRef.child(user!.uid).observe(.value, with: { snapshot in
                    let userInfo = UserInfo(snapshot: snapshot);
                    self.txtEmail.text = userInfo!.email
                    self.txtFirstName.text = userInfo?.firstName
                    self.txtLastName.text = userInfo?.lastName
                })
            } else {
                // do not have auth
                self.performSegue(withIdentifier: self.editProfileToMyAutos, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        }
    }
    
    @IBAction func btnEditClick(_ sender: TransitionButton) {
        guard
            let email = txtEmail.text,
            let password = txtCurrentPassword.text,
            let firstName = txtFirstName.text,
            let lastName = txtLastName.text,
            email.count > 0,
            firstName.count > 0,
            lastName.count > 0
            else {
                return
        }
        
        // check password
        let currentUser = Auth.auth().currentUser;
        let credential = EmailAuthProvider.credential(withEmail: (currentUser?.email)!, password: password)
        currentUser!.reauthenticate(with: credential) { (result, error) in
            if error == nil {
                // collect current password
                // 1.update email
                currentUser?.updateEmail(to: email, completion: { (error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Update Failed",
                                                      message: error?.localizedDescription,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // 2.updatae userinfo
                        let userInfo = UserInfo(email: email, firstName: firstName, lastName: lastName)
                        let initUserInfo = self.userInfoRef.child(currentUser!.uid)
                        initUserInfo.setValue(userInfo.toAnyObject())
                        
                        // 3. goto MyAutos
                        self.performSegue(withIdentifier: self.editProfileToMyAutos, sender: nil)
                    }
                })
            } else {
                // incollect current password
                let alert = UIAlertController(title: "Password Failed",
                                              message: error?.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
