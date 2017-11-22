//
//  ProductTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite
import SwiftyJSON

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
    var arr_main_option = [String]()
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
        change_product_count(main_option: (arr_main_option[(sgm_kinds.selectedIndex)]))
        Main_option = arr_main_option[(sgm_kinds.selectedIndex)]
    }

    func change_product_count(main_option: String)
    {
        print(main_option)
        let count = DBHelper().count_product_in_order_with_main_option(be_product_id: product_id, be_main_option: main_option)
        lbl_count.text = count.count == 0 ? "0" : count[0]["count"].stringValue
    }

    func get_tab_bar2() -> UITabBarItem
    {
        let rootViewController = self.window?.rootViewController as! UITabBarController!
        let tabArray = rootViewController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 1) as! UITabBarItem
        return tabItem
    }

    func product_cost() -> Int
    {
        return Int((lbl_cost.text?.replacingOccurrences(of: CURRENCY, with: "").trimmingCharacters(in: .whitespacesAndNewlines))!)!
    }

    @IBAction func on_clicked_btn_plus(_ sender: UIButton) {
        lbl_count.text = String(Int(lbl_count.text!)! + 1)
        Helper().increment_label(from_value: Total_order_cost, end_value: Total_order_cost + product_cost(), label: lbl_order_cost)
        Total_order_cost = Total_order_cost + product_cost()
        if let badgeValue = get_tab_bar2().badgeValue {
            get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) + 1)
        } else {
            get_tab_bar2().badgeValue = "1"
        }
        check_free_delivery()
        add_to_order(prod_id: sender.tag)
        Main_option = sgm_kinds.items[sgm_kinds.selectedIndex]
    }

    func add_to_order(prod_id: Int)
    {
        if DBHelper().check_exists(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex]) == 0
        {
            DBHelper().add_to_order(be_product_id: prod_id, be_name: lbl_title.text!, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex], be_cost: Double(arr_cost_kinds[sgm_kinds.selectedIndex])!)
        }
        else
        {
            DBHelper().update_from_order_plus(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex])
        }
    }

    func delete_from_order(prod_id: Int)
    {
        let count = DBHelper().check_exists(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex])
        print(count)
        if count > 1
        {
            DBHelper().update_from_order_minus(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex])
        }
        else if count == 1
        {
            let cost_ings = increase_cost_ingredients()
            Helper().increment_label(from_value: Total_order_cost, end_value: Total_order_cost - cost_ings, label: lbl_order_cost)
            Total_order_cost = Total_order_cost - cost_ings
            check_free_delivery()
            DBHelper().delete_product(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex])
            DBHelper().delete_ingredient_of_product(be_product_id: prod_id, be_main_option: sgm_kinds.items[sgm_kinds.selectedIndex])
        }
    }
    
    func increase_cost_ingredients() -> Int
    {
        return DBHelper().costs_ingredients(be_product_id: product_id, be_main_option: Main_option)
    }

    @IBAction func ob_clicked_btn_minus(_ sender: UIButton)
    {
        if Int(lbl_count.text!)! - 1 >= 0
        {
            lbl_count.text = String(Int(lbl_count.text!)! - 1)
            let new_total_cost = Total_order_cost - product_cost()
            Helper().increment_label(from_value: Total_order_cost, end_value: new_total_cost, label: lbl_order_cost)
            Total_order_cost = new_total_cost
            if let badgeValue = get_tab_bar2().badgeValue {
                get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) - 1)
            } else {
                get_tab_bar2().badgeValue = "0"
            }
            delete_from_order(prod_id: sender.tag)
            check_free_delivery()
            Main_option = sgm_kinds.items[sgm_kinds.selectedIndex]
        }
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
        let cost_delivery = check_delivery_cost()
        lbl_delivery.text = cost_delivery
        Total_delivery_cost = Int((cost_delivery.replacingOccurrences(of: CURRENCY, with: "").trimmingCharacters(in: .whitespacesAndNewlines)))!
    }
    
}

