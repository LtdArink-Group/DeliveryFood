//
//  OrderTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 16.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var img_circle: UIImageView!
    
    var lbl_sum_order: UILabel!
    var lbl_sale: UILabel!
    var lbl_delivery: UILabel!
    var lbl_total: UILabel!
    var sw_take_away: UISwitch!
    
    var product_id = 0
    var main_option = ""
    var photo_url: String = ""
    var cost = 0
    var name = ""
    var type = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func on_clicked_btn_plus(_ sender: UIButton) {
        lbl_count.text = String(Int(lbl_count.text!)! + 1)
        Total_order_cost = Total_order_cost + cost
        add_to_order()
        if type != "i"
        {
            if let badgeValue = get_tab_bar2().badgeValue {
                get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) + 1)
            } else {
                get_tab_bar2().badgeValue = "1"
            }
        }
        check_free_delivery()
        self.lbl_cost.text = get_detail_info()
        set_costs_fields()
        Changed_order = true
    }
    
    @IBAction func on_clicked_btn_minus(_ sender: UIButton) {
        if Int(lbl_count.text!)! - 1 >= 0
        {
            lbl_count.text = String(Int(lbl_count.text!)! - 1)
            Total_order_cost = Total_order_cost - cost
            delete_from_order()
            if type != "i"
            {
                if let badgeValue = get_tab_bar2().badgeValue {
                    get_tab_bar2().badgeValue = String((Int(badgeValue) ?? 0) - 1)
                } else {
                    get_tab_bar2().badgeValue = "0"
                }
            }
            check_free_delivery()
            self.lbl_cost.text = get_detail_info()
            set_costs_fields()
            Changed_order = true
        }
    }
    
    func get_detail_info() -> String
    {
        let total = String(Int(lbl_count.text!)! * cost)
        let margin = type == "i" ? "   " : ""
        return margin + "Итого: " + lbl_count.text! + " * " + CURRENCY + String(Int(cost)) + " = " + CURRENCY + total
    }
    
    func add_to_order()
    {
        if type == "i"
        {
            if DBHelper().check_exists_ingredients(be_product_id: product_id, be_main_option: main_option, be_name: name) == 0
            {
                DBHelper().add_to_order_ingredients(be_product_id: product_id, be_name: name, be_main_option: main_option, be_cost: Double(cost))
            }
            else
            {
                DBHelper().update_from_order_ingredients_plus(be_product_id: product_id, be_main_option: main_option, be_name: name)
            }
        }
        else {
            if DBHelper().check_exists(be_product_id: product_id, be_main_option: main_option) == 0
            {
                DBHelper().add_to_order(be_product_id: product_id, be_name: name, be_main_option: main_option, be_cost: Double(cost), be_photo: photo_url)
            }
            else
            {
                DBHelper().update_from_order_plus(be_product_id: product_id, be_main_option: main_option)
            }
        }
    }
    
    func delete_from_order()
    {
        if type == "i"
        {
            let count_prod = DBHelper().check_exists_ingredients(be_product_id: product_id, be_main_option: main_option, be_name: name)
            if count_prod > 1
            {
                DBHelper().update_from_order_ingredients_minus(be_product_id: product_id, be_main_option: main_option, be_name: name)
            }
            else if count_prod == 1
            {
                DBHelper().delete_ingredients_product(be_product_id: product_id, be_main_option: main_option, be_name: name)
            }
        }
        else
        {
            let count = DBHelper().check_exists(be_product_id: product_id, be_main_option: main_option)
            print(count)
            if count > 1
            {
                DBHelper().update_from_order_minus(be_product_id: product_id, be_main_option: main_option)
            }
            else if count == 1
            {
                DBHelper().delete_product(be_product_id: product_id, be_main_option: main_option)
                DBHelper().delete_ingredient_of_product(be_product_id: product_id, be_main_option: main_option)
            }
        }
    }
    
    func check_free_delivery()
    {
        if Total_order_cost >= COST_FREE_DELIVERY
        {
            Total_delivery_cost = 0
        }
        else
        {
            Total_delivery_cost = COST_DELIVERY
        }
    }
    
    func set_costs_fields()
    {
        lbl_sum_order.text = CURRENCY + String(Total_order_cost)
        lbl_sale.text = (sw_take_away?.isOn)! ? CURRENCY + String(Total_order_cost/10) : CURRENCY + "0"
        lbl_delivery.text = (sw_take_away?.isOn)! ? CURRENCY + "0" : CURRENCY + String(Total_delivery_cost)
        lbl_total.text = (sw_take_away?.isOn)! ? CURRENCY + String(Total_order_cost - Total_order_cost/10) : CURRENCY + String(Total_order_cost + Total_delivery_cost)
    }
    
    func get_tab_bar2() -> UITabBarItem
    {
        let rootViewController = self.window?.rootViewController as! UITabBarController!
        let tabArray = rootViewController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 1) as! UITabBarItem
        return tabItem
    }

}
