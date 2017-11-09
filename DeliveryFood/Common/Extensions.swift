//
//  Extensions.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit
import SQLite
import SQLite3

enum UILabelTextPositions : String {
    
    case VERTICAL_ALIGNMENT_TOP = "VerticalAlignmentTop"
    case VERTICAL_ALIGNMENT_MIDDLE = "VerticalAlignmentMiddle"
    case VERTICAL_ALIGNMENT_BOTTOM = "VerticalAlignmentBottom"
    
}

extension UILabel{
    func makeLabelTextPosition (sampleLabel :UILabel?, positionIdentifier : String) -> UILabel
    {
        let rect = sampleLabel!.textRect(forBounds: bounds, limitedToNumberOfLines: 0)
        switch positionIdentifier
        {
        case "VerticalAlignmentTop":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            break
            
        case "VerticalAlignmentMiddle":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2,
                                        width: rect.size.width, height: rect.size.height)
            break
        case "VerticalAlignmentBottom":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            break
        default:
            sampleLabel!.frame = bounds
            break
        }
        return sampleLabel!
    }
}


extension UIButton {
    func playImplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 1.0]
        //1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0, 1.2, 0.8, 1.15, 0.85, 1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0, 1.2, 0.8, 1.15, 0.85, 1.0,1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0, 1.2, 0.8, 1.15, 0.85, 1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(1)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func playExplicitBounceAnimation() {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        var values = [Double]()
        let e = 2.71
        
        for t in 1..<100 {
            let value = 0.6 * pow(e, -0.045 * Double(t)) * cos(0.1 * Double(t)) + 1.0
            
            values.append(value)
        }
        
        
        bounceAnimation.values = values
        bounceAnimation.duration = TimeInterval(5.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func playTransformBounceAnimation() {
        let transformAnim     = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(3 * CGFloat(Double.pi/180), 0, 0, -1)),
                                 NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(3 * CGFloat(Double.pi/180), 0, 0, 1))),
                                 NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                 NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(-8 * CGFloat(Double.pi/180), 0, 0, 1)))]
        transformAnim.keyTimes = [0, 0.349, 0.618, 1, 0.349, 0.618, 1, 0.349, 0.618, 1, 0.349, 0.618, 1]
        transformAnim.duration = 1
        
        layer.add(transformAnim, forKey: "transform")
    }
    
    func animateSolidAway(){
        
        let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = 1
        scaleAnimate.toValue = 0
        scaleAnimate.duration = 0
        scaleAnimate.delegate = self as? CAAnimationDelegate
        scaleAnimate.isRemovedOnCompletion = false
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.add(scaleAnimate, forKey: "scaleSmallAnimation")
        
        
    }
    
    func animateSolidIn(){
        layer.transform = CATransform3DMakeScale(1, 1, 1)
        let scaleAnimate:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = 0
        scaleAnimate.toValue = 1
        scaleAnimate.duration = 0
        scaleAnimate.delegate = self as? CAAnimationDelegate
        scaleAnimate.isRemovedOnCompletion = false
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        layer.add(scaleAnimate, forKey: "scaleNormalAnimation")
    }
    
    func jumpButtonAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 1.3)
        animation.duration = 1
        animation.repeatCount = 10
        animation.autoreverses = true
        layer.add(animation, forKey: nil)
    }
    
    
}

