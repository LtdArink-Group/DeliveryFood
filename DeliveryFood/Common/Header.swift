//
//  Header.swift
//  DeliveryFood
//
//  Created by B0Dim on 13.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit

class Header {

    @objc func on_clicked_call(sender: UIButton)
    {
        let phone:NSURL = NSURL(string: "tel://\(PHONE.digits)")!
        UIApplication.shared.openURL(phone as URL)
    }
    
    //MARK: init smth
    func get_width_screen() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    func init_header_img_view() -> UIImageView
    {
        let width = UIScreen.main.bounds.width
        let imageView = UIImageView(image: UIImage(named: "img_header2"))
        imageView.frame = CGRect(x: 0, y: 64, width: width, height: width/4)
        return imageView
    }
    
    func init_header_lbl_delivery() -> UILabel
    {
        let lbl_delivery = UILabel(frame: CGRect(x: 0, y: 64 + get_width_screen()/6.5, width: get_width_screen()/3, height: 30))
        lbl_delivery.textAlignment = NSTextAlignment.center
        lbl_delivery.font = UIFont(name: "Helvetica", size: 17)
        lbl_delivery.text = CURRENCY + String(Total_delivery_cost)
        lbl_delivery.tag = 1000000000
        return lbl_delivery
    }
    
    func init_header_lbl_order() -> UILabel
    {
        let lbl_order = UILabel(frame: CGRect(x: get_width_screen()/3, y: 64 + get_width_screen()/6.5, width: get_width_screen()/3, height: 30))
        lbl_order.textAlignment = NSTextAlignment.center
        lbl_order.font = UIFont(name: "Helvetica", size: 17)
        lbl_order.tag = 2000000000
        lbl_order.text = CURRENCY + String(Total_order_cost)
        return lbl_order
    }
    
    func init_header_btn_call() -> UIButton
    {
        let btn_call = UIButton(type: UIButtonType.custom) as UIButton
        btn_call.frame = CGRect(x: (get_width_screen()/3) * 2, y: 64, width: get_width_screen()/3, height: get_width_screen()/4)
        btn_call.addTarget(self, action: #selector(Header.on_clicked_call(sender:)), for: UIControlEvents.touchUpInside)
        return btn_call
    }

}
