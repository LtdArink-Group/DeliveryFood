//
//  ProductInfoViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 20.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController, UIScrollViewDelegate {

    var  scrl_main : UIScrollView!
    
    var info: String = ""
    var url_img_product: String = ""
    
    
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
        
        //Add scroll view
        self.scrl_main = UIScrollView(frame: view.bounds)
        self.scrl_main.delegate = self
//        self.view.addSubview(self.scrl_main)
        self.scrl_main.frame = CGRect(x: 0, y: 0, width: width, height: height - 100)
        
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
        button_X.addTarget(self, action: #selector(ProductInfoViewController.on_clicked_btn_close(sender:)), for: UIControlEvents.touchUpInside)
        //add constraints
        self.view.addSubview(button_X)

    }
    
    func init_body(width: CGFloat, height: CGFloat)
    {
        //uilabel
        
        //uiimage
        
        //uidescription
        
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
