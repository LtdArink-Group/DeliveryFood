//
//  NewOrderViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 16.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var img_no_order: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var btn_create_order: UIButton!
    @IBOutlet weak var btn_delete_order: UIBarButtonItem!
    
    @IBOutlet weak var lbl_take_away: UILabel!
    @IBOutlet weak var lbl_sum_order: UILabel!
    @IBOutlet weak var lbl_sale: UILabel!
    @IBOutlet weak var lbl_delivery: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    
    @IBOutlet weak var sw_take_away: UISwitch!
    @IBOutlet weak var sum_order: UILabel!
    @IBOutlet weak var sum_sale: UILabel!
    @IBOutlet weak var sum_delivery: UILabel!
    @IBOutlet weak var sum_total: UILabel!
    
    var arr_order_post_server: JSON = []
    var get_results = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    let requestManager = RequestOrder()
    
    var from_orders = false
    var order: JSON = []
    var status: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preload_form()
    }
    
    func preload_form()
    {
        if self.tabBarController?.tabBar.items?[1].badgeValue == "" || self.tabBarController?.tabBar.items?[1].badgeValue == "0"
        {
            if from_orders
            {
                show_order(order: order)
            }
            else
            {
                go_to_old_order()
            }
        }
        else
        {
            img_no_order.isHidden = true
            scrl_main.isHidden = false
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.rowHeight = 44
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            
            get_results = []
            requestManager.resetGet()
            requestManager.get()
            updateGetResults()
            correct_height_elements()
        }
    }
    
    func correct_height_elements()
    {
        tableView.translatesAutoresizingMaskIntoConstraints = true
        lbl_take_away.translatesAutoresizingMaskIntoConstraints = true
        lbl_sum_order.translatesAutoresizingMaskIntoConstraints = true
        lbl_sale.translatesAutoresizingMaskIntoConstraints = true
        lbl_delivery.translatesAutoresizingMaskIntoConstraints = true
        lbl_total.translatesAutoresizingMaskIntoConstraints = true
        btn_create_order.translatesAutoresizingMaskIntoConstraints = true
        scrl_main.translatesAutoresizingMaskIntoConstraints = true
        sw_take_away.translatesAutoresizingMaskIntoConstraints = true
        sum_order.translatesAutoresizingMaskIntoConstraints = true
        sum_sale.translatesAutoresizingMaskIntoConstraints = true
        sum_delivery.translatesAutoresizingMaskIntoConstraints = true
        sum_total.translatesAutoresizingMaskIntoConstraints = true
        
        let width = UIScreen.main.bounds.size.width
        var height: CGFloat = CGFloat(get_count_products() * 44)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: UIScreen.main.bounds.size.width, height: height)
        
        height = tableView.frame.origin.y + height + 10
        lbl_take_away.frame = CGRect(x: lbl_take_away.frame.origin.x, y: height, width: lbl_take_away.frame.width, height: lbl_take_away.frame.height)
        sw_take_away.frame = CGRect(x: width - 72, y: height, width: sw_take_away.frame.width, height: sw_take_away.frame.height)

        height = height + 40
        lbl_sum_order.frame = CGRect(x: lbl_sum_order.frame.origin.x, y: height, width: lbl_sum_order.frame.width, height: lbl_sum_order.frame.height)
        sum_order.frame = CGRect(x: width - 72, y: height, width: 72, height: sum_order.frame.height)
        height = height + 30
        lbl_sale.frame = CGRect(x: lbl_sale.frame.origin.x, y: height, width: lbl_sale.frame.width, height: lbl_sale.frame.height)
        sum_sale.frame = CGRect(x: width - 72, y: height, width: 72, height: sum_sale.frame.height)
        height = height + 30
        lbl_delivery.frame = CGRect(x: lbl_delivery.frame.origin.x, y: height, width: lbl_delivery.frame.width, height: lbl_delivery.frame.height)
        sum_delivery.frame = CGRect(x: width - 72, y: height, width: 72, height: sum_delivery.frame.height)
        height = height + 30
        lbl_total.frame = CGRect(x: lbl_total.frame.origin.x, y: height, width: lbl_total.frame.width, height: lbl_total.frame.height)
        sum_total.frame = CGRect(x: width - 72, y: height, width: 72, height: sum_total.frame.height)
        
        let btn_width = (UIScreen.main.bounds.size.width - btn_create_order.frame.width)/2
        height = height + 50
        btn_create_order.frame = CGRect(x: btn_width, y: height, width: btn_create_order.frame.width, height: btn_create_order.frame.height)
        height = height + 64
    
        scrl_main.frame = CGRect(x: 0,y: 64, width: width, height: UIScreen.main.bounds.size.height)
        scrl_main.contentSize = CGSize(width: width, height: Helper().scrl_height(height: height, height_screen: UIScreen.main.bounds.size.height))
        
        if from_orders
        {
            set_costs_order_fields()
            if status == "old"
            {
                btn_create_order.setImage(UIImage(named: "btn_reorder"), for: .normal)
                btn_create_order.playImplicitBounceAnimation()
            }
            else {
                btn_create_order.setImage(UIImage(named: "btn_cancel_order"), for: .normal)
            }
        }
        else
        {
            set_costs_fields(total_order_cost: Total_order_cost, delivery_cost: Total_delivery_cost)
            btn_create_order.playImplicitBounceAnimation()
        }
    }
    
    @IBAction func on_clicked_btn_remove(_ sender: UIBarButtonItem) {
        show_message_remove()
    }
    
    func set_costs_fields(total_order_cost: Int, delivery_cost: Int)
    {
        sum_order.text = CURRENCY + String(total_order_cost)
        sum_sale.text = sw_take_away.isOn ? CURRENCY + String(total_order_cost/DELIVERY_DISCONT) : CURRENCY + "0"
        sum_delivery.text = sw_take_away.isOn ? CURRENCY + "0" : CURRENCY + String(delivery_cost)
        sum_total.text = sw_take_away.isOn ? CURRENCY + String(total_order_cost - total_order_cost/DELIVERY_DISCONT) : CURRENCY + String(total_order_cost + delivery_cost)
    }
    
    func set_costs_order_fields()
    {
        sw_take_away.isOn = order["pickup"].boolValue
        let total_order_cost = requestManager.total_order_sum
        let delivery_cost = order["delivery_cost"].intValue
        set_costs_fields(total_order_cost: total_order_cost, delivery_cost: delivery_cost)
    }
    
    @IBAction func on_changed_sw_take_away(_ sender: UISwitch) {
        let total_order_cost = from_orders ? requestManager.total_order_sum : Total_order_cost
        if from_orders
        {
            Total_delivery_cost = total_order_cost >= COST_FREE_DELIVERY ? 0 : Total_delivery_cost
        }
        Take_away = sender.isOn
        sum_sale.text = sender.isOn ? CURRENCY + String(total_order_cost/DELIVERY_DISCONT) : CURRENCY + "0"
        sum_delivery.text = sender.isOn ? CURRENCY + "0" : CURRENCY + String(Total_delivery_cost)
        sum_total.text = sender.isOn ? CURRENCY + String(total_order_cost - total_order_cost/DELIVERY_DISCONT) : CURRENCY + String(total_order_cost + Total_delivery_cost)
    }
    
    
    func show_message_remove()
    {
        let error_string = "Вы уверены, что хотите удалить ваш заказ?"
        let alertController = UIAlertController(title: "Удаление заказа", message:
            error_string, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: { alertAction in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: false, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Удалить", style: UIAlertActionStyle.default, handler: { alertAction in
            alertController.dismiss(animated: true, completion: nil)
            self.remove_order()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func remove_order()
    {
        scrl_main.isHidden = true
        img_no_order.isHidden = false
        tabBarController?.tabBar.items?[1].badgeValue = "0"
        DBHelper().delete_order()
        Total_order_cost = 0
        Total_delivery_cost = COST_DELIVERY
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_order"), object: nil)
    }
    
    func go_to_old_order()
    {
        print("old_order")
        self.performSegue(withIdentifier: "goto_old_order", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateGetResults() {
        get_results = requestManager.getResults
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get_count_products()
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell
        var margin = ""
        var main_option = ""
        if get_results[indexPath.row]["type"].stringValue == "i"
        {
            margin = "   "
        }
        else {
            main_option = " (" + get_results[indexPath.row]["main_option"].stringValue + ")"
        }
        cell.lbl_title?.text = margin + get_results[indexPath.row]["name"].stringValue + main_option
        cell.lbl_cost?.text =  margin + get_detail_info(index: indexPath.row)
        cell.lbl_count.text = get_results[indexPath.row]["count"].stringValue
        cell.product_id = get_results[indexPath.row]["product_id"].intValue
        cell.main_option = get_results[indexPath.row]["main_option"].stringValue
        cell.cost = get_results[indexPath.row]["cost"].intValue
        cell.name = get_results[indexPath.row]["name"].stringValue
        cell.type = get_results[indexPath.row]["type"].stringValue
        cell.sw_take_away = self.view.viewWithTag(1000000000) as? UISwitch
        cell.lbl_sum_order = self.view.viewWithTag(1000000001) as? UILabel
        cell.lbl_sale = self.view.viewWithTag(1000000002) as? UILabel
        cell.lbl_delivery = self.view.viewWithTag(1000000003) as? UILabel
        cell.lbl_total = self.view.viewWithTag(1000000004) as? UILabel
        if from_orders == true
        {
            cell.btn_plus.isHidden = true
            cell.btn_minus.isHidden = true
            cell.lbl_count.isHidden = true
            cell.img_circle.isHidden = true
        }
        else {
            cell.btn_plus.isHidden = false
            cell.btn_minus.isHidden = false
            cell.lbl_count.isHidden = false
            cell.img_circle.isHidden = false
        }
        return cell
    }
    
    func get_detail_info(index: Int) -> String
    {
        let total = String(get_results[index]["count"].intValue * get_results[index]["cost"].intValue)
        return "Итого: " + get_results[index]["count"].stringValue + " * " + CURRENCY + get_results[index]["cost"].stringValue.dropLast(2) + " = " + CURRENCY + total
    }
    
    func get_count_products() -> Int
    {
        return get_results.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if Changed_order == true
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_order"), object: nil)
        }
    }
    
    func show_order(order: JSON)
    {
        img_no_order.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
        scrl_main.isHidden = false
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = 44
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        get_results = []
        requestManager.resetGet()
        requestManager.get_exist_order(order: order["order_products"].arrayValue)
        updateGetResults()
        correct_height_elements()
    }
    
    @IBAction func on_clicked_create_order(_ sender: UIButton)
    {
        if from_orders && status == "old"
        {
            //reorder
        }
        else if from_orders && status != "old"
        {
            //cancel
            if order["status"] == "Новый"
            {
                cancel_order()
            }
            else {
                PageLoading().showLoading()
                ShowError().show_error(text: "Ваш заказ подтвержден. Его отменить нельзя! Позвоните оператору.")
            }
        }
        else {
            let controller : DeliveryAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAddressViewController") as! DeliveryAddressViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cancel_order()
    {
        let url = SERVER_NAME + "/api/orders/\(order["id"].stringValue)/cancel"
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if let json = response.result.value as? [String: Any] {
                    if json["errors"] as? [String: Any] != nil
                    {
                        PageLoading().showLoading()
                        ShowError().show_error(text: "Мы сожалеем, но что-то пошло не так. Проверьте введенные данные.")
                    }
                    else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancel_order"), object: nil)
                        self.navigationController?.popViewController(animated: false)
                    }
                }
        }
    }
    
    
}

class RequestOrder {
    
    var getResults = [JSON]()
    var total_order_sum: Int = 0
    func get()
    {
        self.getResults = DBHelper().total_order()
        print(self.getResults)
    }
    
    func get_exist_order(order: [JSON])
    {
        total_order_sum = 0
        for each in order
        {
            print(each)
            var cost_ings = 0
            if each["ingredients"].arrayValue.count > 0
            {
                for ing in each["ingredients"].arrayValue
                {
                    cost_ings += ing["total_cost"].intValue
                }
            }
            let prod_cost = String((each["total_cost"].intValue - cost_ings) / each["qty"].intValue) + ".0"
            total_order_sum += each["total_cost"].intValue
            self.getResults.append(["product_id" : each["product_id"].stringValue,
                                    "name" : each["product_title"].stringValue,
                                    "main_option" : each["main_option"].stringValue,
                                    "cost" : prod_cost,
                                    "count" : each["qty"].stringValue,
                                    "type" : "p"])
            if each["ingredients"].arrayValue.count > 0
            {
                for ing in each["ingredients"].arrayValue
                {
                    let ing_cost = String(ing["total_cost"].intValue / ing["qty"].intValue) + ".0"
                    self.getResults.append(["product_id" : each["product_id"].stringValue,
                                            "name" : ing["name"].stringValue,
                                            "main_option" : each["main_option"].stringValue,
                                            "cost" : ing_cost,
                                            "count" : ing["qty"].stringValue,
                                            "type" : "i"])
                }
            }
        }
    }
    
    func resetGet() {
        getResults = []
    }
}
