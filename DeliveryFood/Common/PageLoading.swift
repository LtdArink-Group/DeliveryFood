//
//  PageLoading.swift
//  DeliveryFood
//
//  Created by B0Dim on 17.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class PageLoading {
    
    var loadingView = UIView()
    var container = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    func showLoading() {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 100000000
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(self.loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/3, height: win.frame.width/3))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.loadingView.center
        
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = self.loadingView.center
        
        
        self.loadingView.addSubview(container)
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        bad_internet()
    }
    
    func hideLoading(){
        UIView.animate(withDuration: 0.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.container.alpha = 0.0
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }, completion: { finished in
            self.activityIndicator.removeFromSuperview()
            self.container.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let removeView  = win.viewWithTag(100000000)
            removeView?.removeFromSuperview()
        })
    }
    
    func showLoadingProcess(position: Int, count_all: Int) {
        
        if position == 1
        {
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            self.loadingView = UIView(frame: win.frame)
            self.loadingView.tag = 100000000
            self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
            
            win.addSubview(self.loadingView)
            
            container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/3, height: win.frame.width/3))
            container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
            container.layer.cornerRadius = 10.0
            container.layer.borderColor = UIColor.gray.cgColor
            container.layer.borderWidth = 0.5
            container.clipsToBounds = true
            container.center = self.loadingView.center
            
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: win.frame.width/5, height: win.frame.width/5)
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.center = self.loadingView.center
            
            let lbl_count = UILabel(frame: CGRect(x: 0, y: 0, width: win.frame.width/4, height: win.frame.width/4))
            lbl_count.textAlignment = NSTextAlignment.center
            lbl_count.font = UIFont(name: "Helvetica", size: 12)
            lbl_count.textColor = UIColor.white
            lbl_count.text = "\(position) из \(count_all)"
            lbl_count.tag = 100000001
            lbl_count.center = CGPoint(x: self.loadingView.center.x, y: self.loadingView.center.y + 35)
            
            self.loadingView.addSubview(container)
            self.loadingView.addSubview(activityIndicator)
            self.loadingView.addSubview(lbl_count)
            activityIndicator.startAnimating()
        }
        else
        {
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let spinnerView = win.viewWithTag(100000000)
            if spinnerView != nil
            {
                if let lbl_count = spinnerView!.viewWithTag(100000001) as? UILabel
                {
                    lbl_count.text = "\(position) из \(count_all)"
                }
            }
        }
    }
    
    func bad_internet()
    {
        Helper().delay(8)
        {
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let spinnerView  = win.viewWithTag(100000000)
            if spinnerView != nil
            {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                let lbl_internet_error = UILabel(frame: CGRect(x: 0, y: 0, width: win.frame.width/4, height: win.frame.width/5))
                lbl_internet_error.textAlignment = NSTextAlignment.center
                lbl_internet_error.font = UIFont(name: "Helvetica", size: 12)
                lbl_internet_error.lineBreakMode = .byWordWrapping
                lbl_internet_error.numberOfLines = 4
                lbl_internet_error.textColor = UIColor.white
                lbl_internet_error.text = "Ошибка сети. Проверьте интернет соединение"
                lbl_internet_error.center = self.loadingView.center
                self.loadingView.addSubview(lbl_internet_error)
                Helper().delay(2)
                {
                    self.hideLoading()
                    lbl_internet_error.removeFromSuperview()
                }
            }
        }
    }
    
}
