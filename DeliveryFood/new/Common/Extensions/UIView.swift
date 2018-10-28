//
//  UIView+NibLoad.swift
//  CustomButton
//
//  Created by Kirill Averyanov on 21/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

internal extension UIView {

    var defaultTextColor: UIColor {return UIColor(white: 0.2, alpha: 1)}

    //MARK: nibLoad
//  class func viewFromNib(withOwner owner: Any? = nil) -> Self {
//    print(String(describing: type(of: self)))
//    let name = String(describing: type(of: self)).components(separatedBy: ".")[0]
//    let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil)[0]
//    return cast(view)!
//  }
//
//  func loadFromNibIfEmbeddedInDifferentNib() -> Self {
//    let isJustAPlaceholder = subviews.count == 0
//    if isJustAPlaceholder {
//      let theRealThing = type(of: self).viewFromNib()
//      theRealThing.frame = frame
//
//      translatesAutoresizingMaskIntoConstraints = false
//      theRealThing.translatesAutoresizingMaskIntoConstraints = false
//
//      return theRealThing
//    }
//
//    return self
//  }
    
    func addViewFromNib() -> UIView {
        let view = self.loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        return view;
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        //namev xib and class must be the same
        let nib = UINib(nibName: String(describing: type(of: self)).components(separatedBy: ".")[0], bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

//private func cast<T, U>(_ value: T) -> U? {
//  return value as? U
//}

