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

extension Date {
    func set_time_to_date(hour: Int, minute: Int) -> Date
    {
        let greg = Calendar(identifier: .gregorian)
        let now = Date()
        var components = greg.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = hour
        components.minute = minute
        return greg.date(from: components)!
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
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

