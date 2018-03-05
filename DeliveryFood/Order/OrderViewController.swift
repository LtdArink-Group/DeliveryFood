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
        self.navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.updateGetResults), name: NSNotification.Name(rawValue: "get_result_orders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.reload_form), name: NSNotification.Name(rawValue: "cancel_order"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrderViewController.reload_form), name: NSNotification.Name(rawValue: "reload_form"), object: nil)
        preload_form()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        preload_form()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if get_active_orders(arr_orders: get_results).count > 0 {
            reload_form()
        }
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
        if self.tabBarController?.tabBar.items?[1].badgeValue == "" || self.tabBarController?.tabBar.items?[1].badgeValue == "0"
        {
            if form.isEmpty && !request
            {
                request = true
                get_results = []
                requestManager.resetGet()
                requestManager.get()
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
        return arr_orders.filter { ( ST_ACTIVE.contains($0["status"].stringValue)) && Helper().get_date_from_string($0["delivery_time"].stringValue) >= Helper().get_now() }
    }

    func get_old_orders(arr_orders: [JSON]) -> [JSON]
    {
        return arr_orders.filter { Helper().get_date_from_string($0["delivery_time"].stringValue) < Helper().get_now() || $0["status"].stringValue == ST_CANCEL }
    }
    

    func create_form(arr_orders: [JSON])
    {
        
        form
            +++ Section("Активные заказы") { on in
                on.header?.height = {33}
                on.hidden = get_active_orders(arr_orders: arr_orders).count > 0 ? false : true
                for (_, order) in get_active_orders(arr_orders: arr_orders).enumerated() //arr_orders.enumerated()
                {
                    var address = order["address_info"]
                    let total_cost = order["total_cost"].intValue + order["delivery_cost"].intValue
                    let delivery_type = order["pickup"] == true ? "Самовывоз" : "Доставка"
                    let str_address = address["street"].stringValue == "" ? "" : address["street"].stringValue + ", " + address["house"].stringValue + " - кв/оф " + address["office"].stringValue  +  " (" + address["title"].stringValue + ")"
                    on  <<< CustomTimerRow() {
                        $0.cellProvider = CellProvider<CustomTimerCell>(nibName: "CustomTimerCell")
                        $0.cell.height = {99}
                        $0.cell.lbl_title.text = delivery_type + "\n" + str_address + "\n"
                            + Helper().string_date_from_string(order["delivery_time"].stringValue) + " в " + Helper().string_time_from_string(order["delivery_time"].stringValue) + " - " + CURRENCY + String(total_cost)
                        $0.cell.lbl_state.text = order["status"].stringValue
                        $0.cell.lbl_timer.addTime(time: get_rest_time(datetime: order["delivery_time"].stringValue))
                        $0.cell.lbl_timer.start()
                        }.onCellSelection {row,cell in
                            self.go_to_order(order: order, status: "new")
                    }
                }
            }
            
            +++ Section("Предыдущие заказы") { on in
                on.hidden = get_old_orders(arr_orders: arr_orders).count > 0 ? false : true
                for (_, order) in get_old_orders(arr_orders: arr_orders).enumerated() //arr_orders.enumerated()
                {
                    var address = order["address_info"]
                    let total_cost = order["total_cost"].intValue + order["delivery_cost"].intValue
                    let delivery_type = order["pickup"] == true ? "Самовывоз" : "Доставка"
                    let str_address = address["street"].stringValue == "" ? "" : address["street"].stringValue + ", " + address["house"].stringValue + " - кв/оф " + address["office"].stringValue  +  " (" + address["title"].stringValue + ")"
                    on <<< LabelRow() {
                        $0.title = delivery_type + "\n"
                            + str_address + "\n"
                            + Helper().string_date_from_string(order["delivery_time"].stringValue) + " в " + Helper().string_time_from_string(order["delivery_time"].stringValue) + " - " + CURRENCY + String(total_cost)
                        $0.cell.textLabel?.font = UIFont(name: "Helvetica", size: 13)
                        $0.cell.textLabel?.numberOfLines = 2
                        $0.cell.accessoryType = .disclosureIndicator
                        $0.cell.imageView?.image = UIImage(named: Helper().get_icon(title: address["title"].stringValue))
                        }.onCellSelection {row,cell in
                            self.go_to_order(order: order, status: "old")
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
