//
//  ShadowView.swift
//  Bets4Beers
//
//  Created by apple on 4/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear
        {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
