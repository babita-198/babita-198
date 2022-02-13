//
//  Designable.swift
//  ODS
//
//  Created by soc-macmini-64 on 18/10/16.
//  Copyright © 2016 soc-macmini-64. All rights reserved.
//

import UIKit


// MARK :- UIView Designable
//@IBDesignable
extension UIView {
  
    // MARK :- Border color
    @IBInspectable var borderColor: UIColor? {
        get {
            return self.borderColor
        } set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    // MARK :- Border Width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }

    // MARK :- corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
/// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let shadowColor = self.layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
}

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .gray])
        }
    }
}
