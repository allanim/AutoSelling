//
//  SignupViewController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-12.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import TransitionButton
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let signupToMyAutos = "SignupToMyAutos"
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    // user info
    let usersInfoRef = Database.database().reference(withPath: "user-info")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        }
    }
    
    // sign up
    @IBAction func btnSignupClick(_ sender: TransitionButton) {
        guard
            let email = txtEmail.text,
            let password = txtPassword.text,
            let firstName = txtFirstName.text,
            let lastName = txtLastName.text,
            email.count > 0,
            password.count > 0,
            firstName.count > 0,
            lastName.count > 0
            else {
                return
        }
        
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { user, error in
            if let error = error, user == nil {
                // create fail
                let alert = UIAlertController(title: "Sing Up Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                // auto login
                Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { user, error in
                    // save user info
                    let user = Auth.auth().currentUser;
                    let userInfo = UserInfo(email: email, firstName: firstName, lastName: lastName)
                    let initUserInfo = self.usersInfoRef.child(user!.uid)
                    initUserInfo.setValue(userInfo.toAnyObject())
                    
                    // move
                    self.performSegue(withIdentifier: self.signupToMyAutos, sender: nil)
                }
            }
            
        }
    }
}
