//
//  TransitionButton.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-13.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import Foundation
import TransitionButton

public extension TransitionButton {
    
    func customClick(controller: UIViewController, callFunc: ()) {
        self.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            // call
            callFunc
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.stopAnimation(animationStyle: .expand, completion: {
                    let secondVC = UIViewController()
                    controller.present(secondVC, animated: true, completion: nil)
                })
            })
        })
    }
}
