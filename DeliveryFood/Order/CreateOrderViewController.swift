//
//  CreateOrderViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateOrderViewController {
    
    
    func create_array_json_order() -> [[String: Any]]
    {
        var arr_order = [[String: Any]]()
        for each in DBHelper().total_order()
        {
            if each["type"].stringValue == "p"
            {
                let prod = [
                    "product_id": each["product_id"].intValue,
                    "main_option": each["main_option"].stringValue,
                    "qty": each["count"].intValue,
                    "ingredients": create_array_json_ingredients(product_id: each["product_id"].intValue, main_option: each["main_option"].stringValue)
                    ] as [String: Any]
                arr_order.append(prod)
            }
        }
        return arr_order
    }
    
    func create_array_json_ingredients(product_id: Int, main_option: String) -> [[String: Any]]
    {
        var arr_ingred = [[String: Any]]()
        for each in DBHelper().total_order()
        {
            if each["type"].stringValue == "i" && each["product_id"].intValue == product_id && each["main_option"].stringValue == main_option
            {
                let ingred = [
                    "qty": each["count"].intValue,
                    "name": each["name"].stringValue
                ] as [String: Any]
                arr_ingred.append(ingred)
            }
        }
        return arr_ingred
    }
    
    func post_order(address_id: Int, delivery_time: String)
    {
        let params = Take_away == true ? [
            "company_id": COMPANY_ID,
            "account_id" : ID_phone,
            "delivery_time": "\(delivery_time)",
            "order_products": create_array_json_order(),
            "pickup": Take_away
            ]  : [
            "company_id": COMPANY_ID,
            "account_id" : ID_phone,
            "address_id": address_id,
            "delivery_time": "\(delivery_time)",
            "order_products": create_array_json_order()
        ] as [String : Any]
        print(params)
        let url = SERVER_NAME + "/api/orders"
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    if let json = response.result.value as? [String: Any] {
                        print(json)
                        if json["errors"] as? [String: Any] != nil
                        {
                            ShowError().show_error(text: ERR_CHECK_DATA_TIME)
                        }
                        else {
                            self.delete_order_sqlite()
                        }
                    }
                    else {
                        ShowError().show_error(text: ERR_CHECK_INTERNET)
                    }
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_INTERNET)
                }
        }
    }

    func delete_order_sqlite()
    {
        Total_order_cost = 0
        Total_delivery_cost = COST_DELIVERY
        DBHelper().delete_order()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "show_well_done"), object: nil)
    }
    
    
}
