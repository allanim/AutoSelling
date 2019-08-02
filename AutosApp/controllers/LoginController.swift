//
//  LoginController.swift
//  AutosApp
//
//  Created by Allan Im on 2019-07-19.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit
import TransitionButton

class LoginController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swSaved: UISwitch!
    @IBOutlet weak var btnLogin: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let image = UIImage(named: "chevron-sign-to-right")
        
//        btnLogin.setBackgroundImage(image, for: UIControl.State.normal)
        
//        btnLogin.backgroundColor = UIColor(cgColor: "ff0000")
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        btnLogin.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.btnLogin.stopAnimation(animationStyle: .expand, completion: {
                    let secondVC = UIViewController()
                    self.present(secondVC, animated: true, completion: nil)
                })
            })
        })
    }
    
}
