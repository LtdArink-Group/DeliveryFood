//
//  DeliveryInfoView.swift
//  DeliveryFood
//
//  Created by B0Dim on 24.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit

class DeliveryInfoView: UIView {
    
    var lbl_delivery = UILabel()
    var lbl_order = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4)
        let width = UIScreen.main.bounds.width
        let imageView = UIImageView(image: UIImage(named: "img_header2"))
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width/4)
        addSubview(imageView)
        
        self.lbl_delivery.frame = CGRect(x: 0, y: width/6.5, width: width/3, height: 30)
        self.lbl_delivery.textAlignment = NSTextAlignment.center
        self.lbl_delivery.font = UIFont(name: "Helvetica", size: 17)
        self.lbl_delivery.textColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))

        self.lbl_delivery.tag = 10000001
        addSubview(self.lbl_delivery)
        
        self.lbl_order.frame = CGRect(x: width/3, y: width/6.5, width: width/3, height: 30)
        self.lbl_order.textAlignment = NSTextAlignment.center
        self.lbl_order.font = UIFont(name: "Helvetica", size: 17)
        self.lbl_order.text = CURRENCY +  " " + String(COST_ORDER_DEFAULT)
        self.lbl_order.tag = 20000001
        self.lbl_order.textColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        addSubview(self.lbl_order)
        
        let btn_call = UIButton(type: UIButtonType.custom) as UIButton
        btn_call.frame = CGRect(x: (width/3) * 2, y: 0, width: width/3, height: width/4)
        btn_call.addTarget(self, action: #selector(DeliveryInfoView.on_clicked_call(sender:)), for: UIControlEvents.touchUpInside)
        addSubview(btn_call)
    }
    
    @objc func on_clicked_call(sender: UIButton!)
    {
        let phone:NSURL = NSURL(string: "tel://\(PHONE.digits)")!
        UIApplication.shared.openURL(phone as URL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func check_delivery_cost() -> String
    {
        if Total_order_cost >= COST_FREE_DELIVERY
        {
            return CURRENCY + "0"
        }
        else
        {
            return CURRENCY + String(COST_DELIVERY)
        }
    }
    
    func check_free_delivery()
    {
        self.lbl_delivery.text = check_delivery_cost()
        Total_delivery_cost = Int((self.lbl_delivery.text?.replacingOccurrences(of: CURRENCY, with: "").trimmingCharacters(in: .whitespacesAndNewlines))!)!
    }
    
}
