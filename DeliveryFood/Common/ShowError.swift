//
//  ShowError.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
class ShowError {
    
    var errorView = UIView()
    var container = UIView()
    
    func show_error(text: String) {
        PageLoading().hideLoading()
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.errorView = UIView(frame: win.frame)
        self.errorView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        self.errorView.tag = 100000000

        win.addSubview(self.errorView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/2, height: win.frame.width/4))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.errorView.center
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: win.frame.width/2, height: win.frame.width/4))
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "Helvetica", size: 13)
        lbl.numberOfLines = 4
        lbl.textColor = UIColor.white
        lbl.text = "\(text)"
        lbl.tag = 100000001
        lbl.center = CGPoint(x: self.errorView.center.x, y: self.errorView.center.y)
        
        self.errorView.addSubview(container)
        self.errorView.addSubview(lbl)
        
        Helper().delay(1)
        {
            self.hide_error()
        }
    }
    
    func hide_error()
    {
        UIView.animate(withDuration: 3.0, animations: {
            self.container.alpha = CGFloat(0.0)
        })
        Helper().delay(3)
        {
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let remove_error  = win.viewWithTag(100000000)
            remove_error?.removeFromSuperview()
            let remove_lbl  = win.viewWithTag(100000001) as? UILabel
            remove_lbl?.removeFromSuperview()
        }
    }
    
}

