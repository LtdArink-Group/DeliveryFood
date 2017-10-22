//
//  ProductTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_title: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var sgm_kinds: ADVSegmentedControl!
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var btn_additional: UIButton!
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var lbl_count: UILabel!
    
    var lbl_delivery: UILabel!
    var lbl_order_cost: UILabel!
    var arr_cost_kinds = [String]()
    var product_id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        init_sgm_kinds()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func init_sgm_kinds()
    {
        sgm_kinds.addTarget(self, action: #selector(ProductTableViewCell.sgm_kinds_value_changed(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @objc func sgm_kinds_value_changed(sender: AnyObject?)
    {
        Helper().increment_label(from_value: product_cost(), end_value: Int(arr_cost_kinds[(sgm_kinds.selectedIndex)])!, label: lbl_cost)
    }
    
    func get_tab_bar2() -> UITabBarItem
    {
        let rootViewController = self.window?.rootViewController as! UITabBarController!
        let tabArray = rootViewController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 2) as! UITabBarItem
        return tabItem
    }
    
    func product_cost() -> Int
    {
        return Int((lbl_cost.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
    func order_cost() -> Int
    {
        return Int((lbl_order_cost.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
    @IBAction func on_clicked_btn_plus(_ sender: UIButton) {
        lbl_count.text = String(Int(lbl_count.text!)! + 1)
        Helper().increment_label(from_value: order_cost(), end_value: order_cost() + product_cost(), label: lbl_order_cost)
        Total_order_cost = Total_order_cost + product_cost()
        
        if let badgeValue = get_tab_bar2().badgeValue {
            get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) + 1)
        } else {
            get_tab_bar2().badgeValue = "1"
        }
        check_free_delivery()
    }
    
    func add_to_order()
    {
        Arr_order = [
            "id_product": product_id,
            "title": "\(String(describing: lbl_title.text))",
            "qty": "\(String(describing: lbl_count.text))",
            "cost": "\(String(describing: lbl_cost.text))",
            "main_option_id": sgm_kinds.selectedIndex,
            "main_option_title": "\(sgm_kinds.items[sgm_kinds.selectedIndex])"
        ]
    }
    
    func delete_from_order()
    {
        
    }
    
    @IBAction func ob_clicked_btn_minus(_ sender: UIButton) {
        
        if Int(lbl_count.text!)! - 1 >= 0
        {
            lbl_count.text = String(Int(lbl_count.text!)! - 1)
            Helper().increment_label(from_value: order_cost(), end_value: order_cost() - product_cost(), label: lbl_order_cost)
            Total_order_cost = Total_order_cost - product_cost()
            
            if let badgeValue = get_tab_bar2().badgeValue {
                get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) - 1)
            } else {
                get_tab_bar2().badgeValue = "0"
            }
            check_free_delivery()
        }
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

}
