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
    var product_id = 0
    
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
        if get_count_product() == 0
        {
            ShowError().show_error(text: "Для добавления ингредиентов необходимо добавить продукт в корзину")
        }
        else
        {
            lbl_count.text = String(Int(lbl_count.text!)! + 1)
            Helper().increment_label(from_value: Total_order_cost, end_value: Total_order_cost + Int(get_cost_additional_option()), label: lbl_order_cost)
            Total_order_cost = Total_order_cost + Int(get_cost_additional_option())
            check_free_delivery()
            add_to_order()
        }
    }
    
    @IBAction func on_clicked_btn_minus(_ sender: UIButton) {
        if Int(lbl_count.text!)! - 1 >= 0
        {
            lbl_count.text = String(Int(lbl_count.text!)! - 1)
            Helper().increment_label(from_value: Total_order_cost, end_value: Total_order_cost - Int(get_cost_additional_option()), label: lbl_order_cost)
            Total_order_cost = Total_order_cost - Int(get_cost_additional_option())
            delete_from_order()
            check_free_delivery()
        }
    }
    
    func get_count_product() -> Int
    {
        let count = DBHelper().count_product_in_order_with_main_option(be_product_id: product_id, be_main_option: Main_option)
        return count.count == 0 ? 0 : count[0]["count"].intValue
    }
    
    func get_cost_additional_option() -> Double
    {
        return Double(Int((lbl_cost.text?.replacingOccurrences(of: "Цена: " + CURRENCY, with: "").trimmingCharacters(in: .whitespacesAndNewlines))!)!)
    }
    
    func add_to_order()
    {
        if DBHelper().check_exists_ingredients(be_product_id: product_id, be_main_option: Main_option, be_name: lbl_title.text!) == 0
        {
            DBHelper().add_to_order_ingredients(be_product_id: product_id, be_name: lbl_title.text!, be_main_option: Main_option, be_cost: get_cost_additional_option())
        }
        else
        {
            DBHelper().update_from_order_ingredients_plus(be_product_id: product_id, be_main_option: Main_option, be_name: lbl_title.text!)
        }
    }
    
    func delete_from_order()
    {
        let count = DBHelper().check_exists_ingredients(be_product_id: product_id, be_main_option: Main_option, be_name: lbl_title.text!)
        if count > 1
        {
            DBHelper().update_from_order_ingredients_minus(be_product_id: product_id, be_main_option: Main_option, be_name: lbl_title.text!)
        }
        else if count == 1
        {
            DBHelper().delete_ingredients_product(be_product_id: product_id, be_main_option: Main_option, be_name: lbl_title.text!)
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
