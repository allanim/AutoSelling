//
//  LoginController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-19.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import TransitionButton
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swSaved: UISwitch!
    
    let loginToMyAutos = "LoginToMyAutos"
    
    // TabBarIndex
    var sourceTabBarIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // set remember me
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? UITabBarController, let index = self.sourceTabBarIndex {
            dest.selectedIndex = index
        } else if let dest = segue.destination as? SignupViewController {
            dest.sourceTabBarIndex = self.sourceTabBarIndex
        }
    }
    
    func login() {
        guard
            let email = txtEmail.text,
            let password = txtPassword.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Log In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: self.loginToMyAutos, sender: nil)
            }
        }
    }
    
    @IBAction func btnLoginClick(_ sender: TransitionButton) {
        sender.customClick(controller: self, callFunc: login())
    }
    
}
