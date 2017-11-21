//
//  OrderViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 12.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import Crashlytics
import Fabric
import SwiftyJSON

class OrderViewController: FormViewController {

    @IBOutlet weak var img_no_order: UIImageView!
    
    var get_results = [JSON]()
    let requestManager = RequestManagerOrders()
    var request = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.updateGetResults), name: NSNotification.Name(rawValue: "get_result_orders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.reload_form), name: NSNotification.Name(rawValue: "cancel_order"), object: nil)
        preload_form()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preload_form()
    }
    
    @objc func reload_form()
    {
        request = false
        form.removeAll()
        preload_form()
    }
    
    func preload_form()
    {
        self.navigationItem.setHidesBackButton(true, animated:true)
        if self.tabBarController?.tabBar.items?[2].badgeValue == "" || self.tabBarController?.tabBar.items?[2].badgeValue == "0"
        {
            if form.isEmpty && !request
            {
                request = true
                get_results = []
                requestManager.resetGet()
                requestManager.get()
//                updateGetResults()
            }
        }
        else
        {
            navigationController?.popViewController(animated: false)
        }
    }
    
    @objc func updateGetResults()
    {
        get_results = requestManager.getResults
        if requestManager.getResults.count > 0
        {
            create_form(arr_orders: get_results)
        }
        else {
            create_no_order()
        }
    }
    
    func create_no_order()
    {
        tableView!.contentInset.top = -60
        tableView!.addSubview(img_no_order)
    }
    
    func get_active_orders(arr_orders: [JSON]) -> [JSON]
    {
        print(Helper().get_today())
        return arr_orders.filter { ($0["status"].stringValue == "Новый" || $0["status"].stringValue == "Подтвержден") && Helper().get_date_from_string($0["delivery_time"].stringValue) >= Helper().get_now() }
    }

    func get_old_orders(arr_orders: [JSON]) -> [JSON]
    {
        return arr_orders.filter { (($0["status"].stringValue != "Новый" || $0["status"].stringValue != "Подтвержден") && (Helper().get_date_from_string($0["delivery_time"].stringValue) < Helper().get_now()) || $0["status"].stringValue == "Отменен") }
    }
    

    func create_form(arr_orders: [JSON])
    {
        
        form
            +++ Section("Активные заказы") { on in
                on.header?.height = {33}
                on.hidden = get_active_orders(arr_orders: arr_orders).count > 0 ? false : true
                for (_, each) in get_active_orders(arr_orders: arr_orders).enumerated() //arr_orders.enumerated()
                {
                    var address = each["address_info"]
                    let total_cost = each["total_cost"].intValue + each["delivery_cost"].intValue
                    let str_address = address["street"].stringValue == "" ? "Самовывоз" : address["street"].stringValue + ", " + address["house"].stringValue + " - кв/оф " + address["office"].stringValue  +  " (" + address["title"].stringValue + ")"
                    on  <<< CustomTimerRow() {
                        $0.cellProvider = CellProvider<CustomTimerCell>(nibName: "CustomTimerCell")
                        $0.cell.height = {99}
                        $0.cell.lbl_title.text = str_address + "\n"
                            + Helper().string_date_from_string(each["delivery_time"].stringValue) + " в " + Helper().string_time_from_string(each["delivery_time"].stringValue) + " - " + CURRENCY + String(total_cost)
                        $0.cell.lbl_state.text = each["status"].stringValue
                        $0.cell.lbl_timer.addTime(time: get_rest_time(datetime: each["delivery_time"].stringValue))
                        $0.cell.lbl_timer.start()
                        }.onCellSelection {row,cell in
                            self.go_to_order(order: each, status: "new")
                    }
                }
            }
            
            +++ Section("Предыдущие заказы") { on in
//                on.header?.height = {33}
                on.hidden = get_old_orders(arr_orders: arr_orders).count > 0 ? false : true
                for (index, each) in get_old_orders(arr_orders: arr_orders).enumerated() //arr_orders.enumerated()
                {
                    var address = each["address_info"]
                    let total_cost = each["total_cost"].intValue + each["delivery_cost"].intValue
                    let str_address = address["street"].stringValue == "" ? "Самовывоз" : address["street"].stringValue + ", " + address["house"].stringValue + " - кв/оф " + address["office"].stringValue  +  " (" + address["title"].stringValue + ")"
                    on <<< LabelRow() {
                        $0.cell.backgroundColor = index % 2 != 0 ? Helper().UIColorFromRGB(rgbValue: 0xCEF8B6) : .white
                        $0.title = str_address + "\n"
                            + Helper().string_date_from_string(each["delivery_time"].stringValue) + " в " + Helper().string_time_from_string(each["delivery_time"].stringValue) + " - " + CURRENCY + String(total_cost)
                        $0.cell.textLabel?.font = UIFont(name: "Helvetica", size: 13)
                        $0.cell.textLabel?.numberOfLines = 2
                        $0.cell.accessoryType = .disclosureIndicator
                        $0.cell.imageView?.image = UIImage(named: Helper().get_icon(title: address["title"].stringValue))
                        }.onCellSelection {row,cell in
                            self.go_to_order(order: each, status: "old")
                    }
                }
        }
    }
    
    func get_rest_time(datetime: String) -> Double
    {
        let date = Helper().get_date_from_string(datetime)
        let diff = date.seconds(from: Helper().get_now())
        return Double(diff) > 0 ? Double(diff) : 0
    }
    
    func go_to_order(order: JSON, status: String)
    {
        let controller : NewOrderViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
        controller.from_orders = true
        controller.order = order
        controller.status = status
        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class RequestManagerOrders {
    
    var getResults = [JSON]()
    func get()
    {
        let url = SERVER_NAME + "/api/orders?account_id=" + ID_phone
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let results = response.result.value as? [String : Any] {
                self.getResults = []
                let item = JSON(results["orders"] as Any).arrayValue
                self.getResults += item
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "get_result_orders"), object: nil)
            }
        }
    }
    
    func resetGet() {
        getResults = []
    }
}
