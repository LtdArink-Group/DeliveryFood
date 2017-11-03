//
//  NewOrderViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 16.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var btn_create_order: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preload_form()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preload_form()
    }
    
    func preload_form()
    {
        if self.tabBarController?.tabBar.items?[2].badgeValue == "" || self.tabBarController?.tabBar.items?[2].badgeValue == "0"
        {
            go_to_old_order()
        }
        else
        {
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.rowHeight = 44
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            
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
        
        let width = UIScreen.main.bounds.size.width
        var height: CGFloat = CGFloat(get_count_products() * 44)
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: UIScreen.main.bounds.size.width, height: height)
        
        height = tableView.frame.origin.y + height + 10
        lbl_take_away.frame = CGRect(x: lbl_take_away.frame.origin.x, y: height, width: lbl_take_away.frame.width, height: lbl_take_away.frame.height)
        sw_take_away.frame = CGRect(x: width - 72, y: height, width: sw_take_away.frame.width, height: sw_take_away.frame.height)
        height = height + 40
        lbl_sum_order.frame = CGRect(x: lbl_sum_order.frame.origin.x, y: height, width: lbl_sum_order.frame.width, height: lbl_sum_order.frame.height)
        sum_order.frame = CGRect(x: width - 72, y: height, width: sum_order.frame.width, height: sum_order.frame.height)
        height = height + 30
        lbl_sale.frame = CGRect(x: lbl_sale.frame.origin.x, y: height, width: lbl_sale.frame.width, height: lbl_sale.frame.height)
        sum_sale.frame = CGRect(x: width - 72, y: height, width: sum_sale.frame.width, height: sum_sale.frame.height)
        height = height + 30
        lbl_delivery.frame = CGRect(x: lbl_delivery.frame.origin.x, y: height, width: lbl_delivery.frame.width, height: lbl_delivery.frame.height)
        sum_delivery.frame = CGRect(x: width - 72, y: height, width: sum_delivery.frame.width, height: sum_delivery.frame.height)
        height = height + 30
        lbl_total.frame = CGRect(x: lbl_total.frame.origin.x, y: height, width: lbl_total.frame.width, height: lbl_total.frame.height)
        sum_total.frame = CGRect(x: width - 72, y: height, width: sum_total.frame.width, height: sum_total.frame.height)
        
        let btn_width = (UIScreen.main.bounds.size.width - btn_create_order.frame.width)/2
        height = height + 50
        btn_create_order.frame = CGRect(x: btn_width, y: height, width: btn_create_order.frame.width, height: btn_create_order.frame.height)
        
        let scrl_height = height < UIScreen.main.bounds.size.height - 64 ? UIScreen.main.bounds.size.height : height + 60
        scrl_main.contentSize = CGSize(width: width, height: scrl_height)
        scrl_main.frame = CGRect(x: 0,y: 64, width: width, height: UIScreen.main.bounds.size.height)
    }
    
    @IBAction func on_clicked_btn_remove(_ sender: UIBarButtonItem) {
        show_message_remove()
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
        tabBarController?.tabBar.items?[2].badgeValue = "0"
        DBHelper().delete_order()
        self.tabBarController?.selectedIndex = 0
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get_count_products()
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell
        cell.lbl_title?.text = "Бургер Баффало"
        cell.lbl_cost?.text = "Цена 150Р * 10 = 1500Р"
        cell.lbl_count.text = "3"
        return cell
    }
    
    func get_count_products() -> Int
    {
        return 1
    }
    
    
    
}



class RequestOrder {
    
    var getResults = [JSON]()
    func get()
    {
        self.getResults = []
        

    }
    
    func resetGet() {
        getResults = []
    }
}
