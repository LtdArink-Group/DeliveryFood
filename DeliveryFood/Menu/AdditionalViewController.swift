//
//  AdditionalViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 04.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AdditionalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var product_id = 0
    var arr_additionals = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
        NotificationCenter.default.addObserver(self, selector: #selector(AdditionalViewController.go_to_back_remove), name: NSNotification.Name(rawValue: "remove_order"), object: nil)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = 57
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        scrl_main.contentSize = CGSize(width: width, height: bounds.size.height)
        scrl_main.frame = CGRect(x: 0,y: width/4 + 64,width: width,height: height)
        scrl_main.translatesAutoresizingMaskIntoConstraints = false
        
        init_header()
    }
    
    
    @objc func go_to_back_remove()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_order_ingredients"), object: nil)
        go_to_back()
    }

    
    @objc func go_to_back()
    {
        navigationController?.popViewController(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "come_from_ingredients"), object: nil)
    }
    
    func init_header()
    {
        view.addSubview(Header().init_header_img_view())
        view.addSubview(Header().init_header_lbl_delivery())
        view.addSubview(Header().init_header_lbl_order())
        let btn_call = UIButton(type: UIButtonType.custom) as UIButton
        btn_call.frame = CGRect(x: (Header().get_width_screen()/3) * 2, y: 64, width: Header().get_width_screen()/3, height: Header().get_width_screen()/4)
        btn_call.addTarget(self, action: #selector(ProductViewController.on_clicked_call(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn_call)
        
        init_table_view()
        set_cost_order()
    }
    
    
    @objc func on_clicked_call(sender: UIButton!)
    {
        Header().on_clicked_call(sender: sender)
    }
    
    func init_table_view()
    {
        let height = UIScreen.main.bounds.height
        tableView.frame = CGRect(x: 0, y: 33, width: Header().get_width_screen(), height: height - Header().get_width_screen()/4 - 33)
    }
    
    func set_cost_order()
    {
        let lbl_delivery = self.view.viewWithTag(1) as? UILabel
        lbl_delivery?.text = CURRENCY + String(Total_delivery_cost)
        lbl_delivery?.textColor = UIColor.white

        let lbl_order = self.view.viewWithTag(2) as? UILabel
        lbl_order?.text = CURRENCY + String(Total_order_cost)
        lbl_order?.textColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_additionals.count
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdditionalTableViewCell
        let name = arr_additionals[indexPath.row]["name"].stringValue
        cell.lbl_title.text = name
        cell.lbl_cost.text = "Цена: " + CURRENCY + arr_additionals[indexPath.row]["cost"].stringValue
        cell.product_id = product_id
        cell.lbl_delivery = self.view.viewWithTag(1000000000) as? UILabel
        cell.lbl_delivery.textColor = UIColor.white
        cell.lbl_order_cost = self.view.viewWithTag(2000000000) as? UILabel
        cell.lbl_count.text = String(get_choosen_ingredients(product_id: product_id, name: name))
        return cell
    }
    
    func get_choosen_ingredients(product_id: Int, name: String) -> Int
    {
        for ing in DBHelper().count_product_ingredients_in_order(be_product_id: product_id, be_name: name, be_main_option:  Main_option)
        {
            return ing["count"].intValue
        }
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

