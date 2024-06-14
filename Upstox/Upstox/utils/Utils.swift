//
//  Utils.swift
//  Upstox
//
//  Created by Pushkar Dubey on 13/06/24.
//

import Foundation
import UIKit

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        self.layer.masksToBounds = false
        layer.addSublayer(border)
    }
}

extension UIView {
    func addBorderAtTopwith(radius: CGFloat, borderColor: UIColor) {
        let layer = self.layer
        layer.cornerRadius = radius
            layer.shadowColor = borderColor.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
            layer.shadowRadius = 1
            layer.shadowOpacity = 1
            layer.masksToBounds = false
            
            let spread: CGFloat = 0.0
            if spread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
            
            self.superview?.bringSubviewToFront(self)
        }
}
