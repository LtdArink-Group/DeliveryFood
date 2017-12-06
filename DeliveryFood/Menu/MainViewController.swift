//
//  MainViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import Eureka
import SwiftyJSON
import SQLite

class MainViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        PageLoading().showLoading()
        DBHelper().create_tables()
        get_company_info()
        
        ID_phone = UIDevice.current.identifierForVendor!.uuidString
    }
    
    func get_company_info()
    {
        let url = SERVER_NAME + "/api/companies/" + String(COMPANY_ID)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let json = response.result.value  as? [String: Any] {
                let contact_info = json["contact_info"] as! [String: Any]
                PHONE = contact_info["phone"] as! String
                COMPANY_EMAIL = [contact_info["email"] as! String]
                GEOTAG = contact_info["geotag"] as! [String]
                let dev = json["delivery"] as! [String: Any]
                COST_DELIVERY = dev["cost"] as! Int
                let period = dev["period"] as! [String: Any]
                let start = (period["start"] as! String!)
                let end = period["end"] as! String!
                WORK_HOUR_FROM = self.get_hour(time: start!)
                WORK_HOUR_TO = self.get_hour(time: end!)
                WORK_MINUTES_FROM = self.get_minutes(time: start!)
                WORK_MINUTES_TO = self.get_minutes(time: end!)
                COST_FREE_DELIVERY = dev["free_shipping"] as! Int
                DELIVERY_DISCONT = dev["pickup_discount"] as! Int
                COMPANY_INFO = json["description"] as! String
                self.get_categories_info()
            }
        }
    }
    
    func get_hour(time: String) -> Int
    {
        let arr_time = time.split(separator: " ")[0].split(separator: ":")
        return Int(arr_time[0])!
    }
    
    func get_minutes(time: String) -> Int
    {
        let arr_time = time.split(separator: " ")[0].split(separator: ":")
        return Int(arr_time[1])!
    }
    
    func get_categories_info()
    {
        let url = SERVER_NAME + "/api/categories?company_id=" + String(COMPANY_ID)
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let json = response.result.value  as? [String: Any] {
                let categories = json["categories"] as! [[String: Any]]
                self.create_form(arr_categories: categories)
            }
        }
    }
    
    func create_form(arr_categories: [[String: Any]])
    {
        form
            +++ Section() {
                $0.header = HeaderFooterView<DeliveryInfoView>(.class)
                }
            +++ Section("Выберите категорию") {on in
                on.header?.height = {20}
                for each in arr_categories
                {
                    let name = (each["name"] as! String)
                    on <<< LabelRow() {
                        $0.title = name
                        $0.cell.imageView?.image = UIImage(named: each["icon_type"]! as! String)
                        $0.cell.accessoryType = .disclosureIndicator
                        $0.cell.tag = each["id"] as! Int
                        }.onCellSelection {cell, row in
                            self.go_to_category(title: name, id: cell.tag)
                    }
            }
        }
        set_tabbar_value()
        PageLoading().hideLoading()
    }
    
    func set_tabbar_value()
    {
        Total_order_cost = DBHelper().sum_products_order() + DBHelper().sum_ingredients_order()
        tabBarController?.tabBar.items?[1].badgeValue = DBHelper().count_prod_in_order() > 0 ? String(DBHelper().count_prod_in_order()) : "0"
        set_order_cost()
        check_free_delivery()
    }
    
    func set_order_cost()
    {
        let lbl_order = self.view.viewWithTag(20000001) as? UILabel
        lbl_order?.text = CURRENCY + String(Total_order_cost)
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
        let lbl_delivery = self.view.viewWithTag(10000001) as? UILabel
        lbl_delivery?.text = check_delivery_cost()
        Total_delivery_cost = Int((lbl_delivery?.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
    
    func go_to_category(title: String, id: Int)
    {
        let controller : ProductViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        controller.navigationItem.title = title
        controller.category_id = id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func update_header_costs()
    {
        set_order_cost()
        check_free_delivery()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "come_to_products"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "remove_total_order"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "order_done"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

