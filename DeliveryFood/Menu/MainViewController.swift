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
    
    var pullRefreshing: PullRefreshing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false) //tv todo
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        DBHelper().create_tables()

        ID_phone = Utils.shared.phoneId // UIDevice.current.identifierForVendor!.uuidString
        
        pullRefreshing = PullRefreshing(tableView: tableView, action: {self.refresh()})
        
    }
    
    func refresh() {

        form.removeAll()
        categories = nil
        get_company_info()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if categories == nil {
            PageLoading().showLoading()
            get_company_info()
        }
        
        set_tabbar_value()
    }

    
    func get_company_info()
    {
        setEnabledOtherTabItems(enabled: false)
        
        let url = SERVER_NAME + "/api/companies/" + String(COMPANY_ID)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let json = response.result.value  as? [String: Any] {
                let contact_info = json["contact_info"] as! [String: Any]
                PHONE = contact_info["phone"] as! String
                COMPANY_EMAIL = [contact_info["email"] as! String]
                GEOTAG = contact_info["geotag"] as! [String]
                GEOTAG_CAFE = contact_info["geotag_cafe"] as! [String]
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
                COMPANY_ADDRESSES = json["addresses"] as! [[String: Any]]
                WORK_DAYS = JSON(json["schedules"] as Any).arrayValue
                self.get_categories_info()
            } else {
                PageLoading().hideLoading()
                self.pullRefreshing.showErrorMessage()

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
    
    var categories: [[String : Any]]?
    func get_categories_info()
    {
        let url = SERVER_NAME + "/api/categories?company_id=" + String(COMPANY_ID)
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let json = response.result.value  as? [String: Any] {
                self.categories = json["categories"] as? [[String: Any]]
                self.create_form(arr_categories: self.categories)
                
                self.pullRefreshing.hideErrorMessage()
                self.pullRefreshing.isEnabled = false;
                self.setEnabledOtherTabItems(enabled: true)
            }
        }
    }
    
    var orderStatusPanel: OrderStatusPanel!;
    func create_form(arr_categories: [[String: Any]]?)
    {
        form
//            +++ Section() { //tv todo del
//                $0.header = HeaderFooterView<DeliveryInfoView>(.class)
//                }
            +++ Section() { section in
                var header = HeaderFooterView<OrderStatusPanel>(.class)
                header.height = {80}
                
                header.onSetupView = { view, _ in
                    self.orderStatusPanel = view;
                }
                section.header = header
            }
            +++ Section("Выберите категорию") {on in
                on.header?.height = {20}
            for each in arr_categories!
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
//        tabBarController?.tabBar.items?[1].badgeValue = DBHelper().count_prod_in_order() > 0 ? String(DBHelper().count_prod_in_order()) : "0" //tv todo del
        
        
        MainViewController.updateOrderStatusPanel(self.orderStatusPanel)

    }
    
    
    //tv todo move to better place
    class func updateOrderStatusPanel(_ orderStatusPanel: OrderStatusPanel?) {
        if (orderStatusPanel != nil) {
            MainViewController.set_order_cost(orderStatusPanel!)
            MainViewController.check_free_delivery(orderStatusPanel!)
        }
    }
    
    class func set_order_cost(_ orderStatusPanel: OrderStatusPanel)
    {
        //tv todo del
//        let lbl_order = self.view.viewWithTag(20000001) as? UILabel
//        lbl_order?.text = CURRENCY + String(Total_order_cost)
        
        orderStatusPanel.totalCost = Total_order_cost
        orderStatusPanel.productCount = DBHelper().count_prod_in_order() > 0 ?  DBHelper().count_prod_in_order()  : 0
    }
    
    class func check_delivery_cost() -> Int
    {
        if Total_order_cost >= COST_FREE_DELIVERY
        {
            //return CURRENCY + "0" //tv todo del
            return 0
        }
        else
        {
            //return CURRENCY + String(COST_DELIVERY) //tv todo del
            return COST_DELIVERY
        }
    }
    
    class func check_free_delivery(_ orderStatusPanel: OrderStatusPanel)
    {
//        let lbl_delivery = self.view.viewWithTag(10000001) as? UILabel
//        lbl_delivery?.text = check_delivery_cost()
//        Total_delivery_cost = Int((lbl_delivery?.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
        Total_delivery_cost = check_delivery_cost()
        orderStatusPanel.deliveryCost = Total_delivery_cost
        
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
        MainViewController.set_order_cost(orderStatusPanel)
        MainViewController.check_free_delivery(orderStatusPanel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "come_to_products"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "remove_total_order"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.update_header_costs), name: NSNotification.Name(rawValue: "order_done"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: inner helper
    func setEnabledOtherTabItems(enabled: Bool) {
        self.tabBarController?.tabBar.items?.forEach({ (item) in
            if item != self.tabBarController?.tabBar.selectedItem {
                item.isEnabled = enabled
            }
        })
    }
}

