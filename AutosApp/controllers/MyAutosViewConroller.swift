//
//  MyAutosViewConroller.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-12.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import Firebase
import LGButton
import TransitionButton

class MyAutosViewController: UIViewController {
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var viewLogout: UIView!
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUserEmail: UILabel!
    
    var isLoginUser = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check auth
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                // have auth
                self.isLoginUser = true
                
                self.viewLogin.isHidden = true
                self.viewUserInfo.isHidden = false
                self.viewLogout.isHidden = false
                
                // set user info
                let userInfoRef = Database.database().reference(withPath: "user-info")
                userInfoRef.child(user!.uid).observe(.value, with: { snapshot in
                    let userInfo = UserInfo(snapshot: snapshot);
                    self.lbUserName.text = "Hello " + userInfo!.fullName
                    self.lbUserEmail.text = userInfo?.email
                })
            } else {
                // do not have auth
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
        } else if let dest = segue.destination as? EditProfileViewController {
            dest.sourceTabBarIndex = self.tabBarController?.selectedIndex
        } else if let dest = segue.destination as? ChangePasswordViewController {
            dest.sourceTabBarIndex = self.tabBarController?.selectedIndex
        } else if let dest = segue.destination as? SellMyAutosViewController {
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
    
    func menuGoTo(_ btn: LGButton, withIdentifier: String) {
        btn.isLoading = true
        btn.loadingString = "Lodding..."
        btn.loadingColor = UIColor.white
        btn.bgColor = UIColor.greenNephritis
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.performSegue(withIdentifier: withIdentifier, sender: nil)
            
            btn.bgColor = UIColor.white
            btn.isLoading = false
        }
    }
    
    func menuHaveToLogin(_ btn: LGButton) {
        btn.isLoading = true
        btn.loadingString = "Have to login"
        btn.loadingColor = UIColor.white
        btn.bgColor = UIColor.redPomegranate
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            btn.bgColor = UIColor.white
            btn.isLoading = false
        }
    }
    
    @IBAction func btnLogoutClick(_ sender: TransitionButton) {
        sender.customClick(controller: self, callFunc: logout())
    }
    
    @IBAction func menuMySavedAutosClick(_ sender: LGButton) {
    }
    
    @IBAction func menuSellMyAutosClick(_ sender: LGButton) {
        if (isLoginUser) {
            self.menuGoTo(sender, withIdentifier: "MyAutosToSellMyAutos")
        } else {
            self.menuHaveToLogin(sender)
        }
    }
    
    @IBAction func menuEditProfileClick(_ sender: LGButton) {
        if (isLoginUser) {
            self.menuGoTo(sender, withIdentifier: "MyAutosToEditProfile")
        } else {
            self.menuHaveToLogin(sender)
        }
    }
    
    @IBAction func menuChangePasswordClick(_ sender: LGButton) {
        if (isLoginUser) {
            self.menuGoTo(sender, withIdentifier: "MyAutosToChangePassword")
        } else {
            self.menuHaveToLogin(sender)
        }
    }
    
}
