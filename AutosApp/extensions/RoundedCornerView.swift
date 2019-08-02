//
//  RoundedCornerView.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-01.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    
    // if cornerRadius variable is set/changed, change the corner radius of the UIView
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shadowEffact: Bool = false {
        didSet {
            if ( shadowEffact ) {
                layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
                layer.shadowColor = UIColor.shadow.cgColor
                layer.shadowOpacity = 1
                layer.shadowOffset = CGSize(width: 0.5, height: 10)
                layer.shadowRadius = 15
                layer.masksToBounds = false
            }
        }
    }
    
}
