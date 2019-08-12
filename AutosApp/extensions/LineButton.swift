//
//  LineView.swift
//  AutosApp
//
//  Created by Allan Im on 2019-08-08.
//  Copyright © 2019 Allan Im. All rights reserved.
//

import UIKit

@IBDesignable
class LineButton: UIButton {
    
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            if ( borderWidth > 0 ) {
                let border = CALayer()
                border.frame = CGRect.init(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
                border.backgroundColor = UIColor.line.cgColor
                layer.addSublayer(border)
            }
        }
    }
    
}
