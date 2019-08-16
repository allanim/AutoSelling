//
//  MyAutosViewConroller.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-12.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import TransitionButton
import Firebase

class MyAutosViewController: UIViewController {
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var viewLogout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check login
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.viewLogin.isHidden = true
                self.viewUserInfo.isHidden = false
                self.viewLogout.isHidden = false
            } else {
                self.viewLogin.isHidden = false
                self.viewUserInfo.isHidden = true
                self.viewLogout.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? LoginViewController {
            dest.sourceTabBarIndex = self.tabBarController?.selectedIndex
        } else if let dest = segue.destination as? SignupViewController {
            dest.sourceTabBarIndex = self.tabBarController?.selectedIndex
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBAction func btnLogoutClick(_ sender: TransitionButton) {
        sender.customClick(controller: self, callFunc: logout())
    }
    

}
