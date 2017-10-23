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
    var title_product: String = ""
    
    
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
        self.scrl_main.frame = CGRect(x: 0, y: 85, width: width, height: height - 145)
        self.view.addSubview(self.scrl_main)

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
        let lbl_title = UILabel(frame: CGRect(x: 0, y: 37, width: width, height: 34))
        lbl_title.textAlignment = NSTextAlignment.center
        lbl_title.font = UIFont(name: "Helvetica-Bold", size: 30)
        lbl_title.textColor = UIColor(red: 189, green: 189, blue: 189, alpha: 1.0)
        lbl_title.text = title_product
        self.view.addSubview(lbl_title)
        
        //Add line
        let image = UIImage(named: "line_description")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 30, y: 75, width: width - 60, height: 2)
        self.view.addSubview(imageView)
        
        //uiimage
        let img_product = UIImageView()
        img_product.sd_setImage(with: URL(string: url_img_product), placeholderImage: UIImage(named: "img_translucent"))
        img_product.frame = CGRect(x: 30, y: 10, width: width - 60, height: (width - 60) / 1.6)
        img_product.layer.borderWidth = 0.5
        img_product.layer.masksToBounds = false
        img_product.layer.borderColor = UIColor.gray.cgColor
        img_product.clipsToBounds = true
        self.scrl_main.addSubview(img_product)
        
        //uidescription
        let lbl_description = UILabel(frame: CGRect(x: 30, y: Int((width - 60) / 1.6 + 15), width: (Int(width - 60)), height: 22))
        lbl_description.textAlignment = NSTextAlignment.left
        lbl_description.text = info
        lbl_description.font = UIFont(name: "Helvetica", size: 16)
        lbl_description.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl_description.textColor = UIColor(red: 189, green: 189, blue: 189, alpha: 1.0)
        let countline: Int = Int(info.characters.count / 34) + 1
        lbl_description.numberOfLines = countline
        lbl_description.makeLabelTextPosition(sampleLabel: lbl_description, positionIdentifier: UILabelTextPositions.VERTICAL_ALIGNMENT_TOP.rawValue)
        lbl_description.frame = CGRect(x: 30, y: Int((width - 60) / 1.6 + 15), width: Int(lbl_description.frame.width), height: countline * 22)

        self.scrl_main.addSubview(lbl_description)
        self.scrl_main.contentSize = CGSize(width: width, height: img_product.frame.height + lbl_description.frame.height + 40)
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
