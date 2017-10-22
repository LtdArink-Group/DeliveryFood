//
//  AdditionalTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 05.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AdditionalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var lbl_count: UILabel!
    
    var lbl_order_cost: UILabel!
    var lbl_delivery: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func on_clicked_btn_plus(_ sender: UIButton) {
        lbl_count.text = String(Int(lbl_count.text!)! + 1)
        Helper().increment_label(from_value: order_cost(), end_value: order_cost() + product_cost(), label: lbl_order_cost)
        Total_order_cost = Total_order_cost + product_cost()
        check_free_delivery()
        
        if let badgeValue = get_tab_bar2().badgeValue {
            get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) + 1)
        } else {
            get_tab_bar2().badgeValue = "1"
        }
    }
    
    @IBAction func on_clicked_btn_minus(_ sender: UIButton) {
        if Int(lbl_count.text!)! - 1 >= 0
        {
            lbl_count.text = String(Int(lbl_count.text!)! - 1)
            Helper().increment_label(from_value: order_cost(), end_value: order_cost() - product_cost(), label: lbl_order_cost)
            Total_order_cost = Total_order_cost - product_cost()
            check_free_delivery()
            
            if let badgeValue = get_tab_bar2().badgeValue {
                get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) - 1)
            } else {
                get_tab_bar2().badgeValue = "0"
            }
        }
    }
    
    func product_cost() -> Int
    {
        return Int((lbl_cost.text?.replacingOccurrences(of: "Цена: " + CURRENCY, with: ""))!)!
    }
    
    func order_cost() -> Int
    {
        return Int((lbl_order_cost.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
    func check_free_delivery()
    {
        if Total_order_cost >= 1000
        {
            lbl_delivery.text = CURRENCY + "0"
        }
        else
        {
            lbl_delivery.text = CURRENCY + String(COST_DELIVERY)
        }
        Total_delivery_cost = Int((lbl_delivery.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
    func get_tab_bar2() -> UITabBarItem
    {
        let rootViewController = self.window?.rootViewController as! UITabBarController!
        let tabArray = rootViewController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 2) as! UITabBarItem
        return tabItem
    }
    
    
    
}
