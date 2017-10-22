//
//  AdditionalViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 04.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
import Fabric
import SwiftyJSON

class AdditionalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var arr_additionals = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
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
        let lbl_order = self.view.viewWithTag(2) as? UILabel
        lbl_order?.text = CURRENCY + String(Total_order_cost)
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
        cell.lbl_title.text = arr_additionals[indexPath.row]["name"].stringValue
        cell.lbl_cost.text = "Цена: " + CURRENCY + arr_additionals[indexPath.row]["cost"].stringValue
        cell.lbl_delivery = self.view.viewWithTag(1) as? UILabel
        cell.lbl_order_cost = self.view.viewWithTag(2) as? UILabel
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

