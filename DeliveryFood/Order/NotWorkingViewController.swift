//
//  NotWorkingViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 15.12.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//


import UIKit

class NotWorkingViewController: UIViewController, UIScrollViewDelegate {
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        let visuaEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visuaEffectView.frame = self.view.bounds
        visuaEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(visuaEffectView)
        
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        
        init_btn_close(width: width, height: height)
        init_body(width: width, height: height)
    }
    
    func init_btn_close(width: CGFloat, height: CGFloat)
    {
        let button_X = UIButton(type: UIButtonType.custom) as UIButton
        button_X.frame = CGRect(x: width/2 - 10, y: height - 60, width: 40, height: 40)
        let button_X_image = UIImage(named: "img_close_white") as UIImage?
        button_X.setImage(button_X_image, for: .normal)
        button_X.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button_X.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        button_X.addTarget(self, action: #selector(NotWorkingViewController.on_clicked_btn_close(sender:)), for: UIControlEvents.touchUpInside)
        //add constraints
        self.view.addSubview(button_X)
        
    }
    
    func init_body(width: CGFloat, height: CGFloat)
    {
//        lbl_clock.text = "Доставка" + TIME_ZONE_TITLE + ":" + Helper().get_schedules()
        
        //uilabel
        let lbl_title = UILabel(frame: CGRect(x: 16, y: 37, width: width - 16, height: 170))
        lbl_title.textAlignment = NSTextAlignment.center
        lbl_title.font = UIFont(name: "Helvetica-Bold", size: 17)
        lbl_title.textColor = UIColor(red: 189, green: 189, blue: 189, alpha: 1.0)
        lbl_title.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl_title.numberOfLines = 7
        lbl_title.text = ERROR_DELIVERY_NOT_WORKING
        self.view.addSubview(lbl_title)
        
        let info = Helper().get_schedules()
        //uidescription
        let lbl_description = UILabel(frame: CGRect(x: 0, y: 187, width: width, height: 22 * 8))
        lbl_description.textAlignment = NSTextAlignment.center
        lbl_description.text = info
        lbl_description.font = UIFont(name: "Helvetica", size: 18)
        lbl_description.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl_description.textColor = UIColor(red: 189, green: 189, blue: 189, alpha: 1.0)
        lbl_description.numberOfLines = 8
        self.view.addSubview(lbl_description)
    }
    
    
    @objc func on_clicked_btn_close(sender:UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

