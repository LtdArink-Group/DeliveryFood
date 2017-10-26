//
//  MainViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import ASHorizontalScrollView
import Crashlytics
import Fabric
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
                print(PHONE)
//                COST_DELIVERY = json["cost_delivery"] as! Int
//                COST_FREE_DELIVERY = json["cost_free_delivery"] as! Int
                self.get_categories_info()
            }
        }
    }
    
    func get_categories_info()
    {
        let url = SERVER_NAME + "/api/categories?company_id=" + String(COMPANY_ID)
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
        tabBarController?.tabBar.items?[2].badgeValue = DBHelper().count_prod_in_order() > 0 ? String(DBHelper().count_prod_in_order()) : ""
        set_order_cost()
        check_free_delivery()
    }
    
    func set_order_cost()
    {
        let lbl_order = self.view.viewWithTag(2) as? UILabel
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
        let lbl_delivery = self.view.viewWithTag(1) as? UILabel
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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

