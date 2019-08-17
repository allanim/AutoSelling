//
//  ChangePasswordViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-17.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase
import TransitionButton

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    
    let changePasswordToMyAutos = "ChangePasswordToMyAutos"
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check authrization
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user == nil {
                self.performSegue(withIdentifier: self.changePasswordToMyAutos, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        }
    }
    
    @IBAction func btnChangePassword(_ sender: TransitionButton) {
        guard
            let newPassword = txtNewPassword.text,
            let confirmPassword = txtConfirmPassword.text,
            let currentPassword = txtCurrentPassword.text,
            newPassword.count > 0,
            confirmPassword.count > 0
            else {
                return
        }
        
        if (newPassword == confirmPassword) {
            // check password
            let currentUser = Auth.auth().currentUser;
            let credential = EmailAuthProvider.credential(withEmail: (currentUser?.email)!, password: currentPassword)
            currentUser!.reauthenticate(with: credential) { (result, error) in
                if error == nil {
                    // collect current password
                    // 1.update password
                    currentUser?.updatePassword(to: newPassword, completion: { (error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Change passwowrd Failed",
                                                          message: error?.localizedDescription,
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            // 2. goto MyAutos
                            self.performSegue(withIdentifier: self.changePasswordToMyAutos, sender: nil)
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
        } else {
            // not match
            let alert = UIAlertController(title: "Password Faild",
                                          message: "Password is not match",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
}
