//
//  ProductViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
import Fabric
import Alamofire
import SwiftyJSON
import SDWebImage

class ProductViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var category_id: Int = 0
    var get_results = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let requestManager = RequestManagerProducts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = UIScreen.main.bounds.height == 568 ? 381 : 421
        
        tableView.delegate = self
        
        init_header()
        
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.updateGetResults), name: NSNotification.Name(rawValue: "get_result_product_updated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.go_to_back_remove), name: NSNotification.Name(rawValue: "remove_order"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.go_to_back_remove), name: NSNotification.Name(rawValue: "remove_order_ingredients"), object: nil)
        
        get_results = []
        updateGetResults()
        requestManager.resetGet()
        requestManager.get(id: category_id)
    }
    
    @objc func go_to_back()
    {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func go_to_back_remove()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_total_order"), object: nil)
        go_to_back()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "come_to_products"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ProductViewController.update_header_costs), name: NSNotification.Name(rawValue: "come_from_ingredients"), object: nil)
        Main_option = ""
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
        
        init_table_view(width: Header().get_width_screen())
        set_cost_order()
    }
    
    @objc func on_clicked_call(sender: UIButton!)
    {
        Header().on_clicked_call(sender: sender)
    }
    
    func init_table_view(width: CGFloat)
    {
        let height = UIScreen.main.bounds.height
        tableView.frame = CGRect(x: 0, y: 64 + width/4, width: width, height: height - width/4 - 64)
    }
    
    func set_cost_order()
    {
        (self.view.viewWithTag(1000000000) as? UILabel)?.text = CURRENCY + String(Total_delivery_cost)
        (self.view.viewWithTag(2000000000) as? UILabel)?.text = CURRENCY + String(Total_order_cost)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return get_results.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        print(get_results[indexPath.row]["title"].stringValue)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        cell.img_product.sd_setImage(with: URL(string: get_results[indexPath.row]["photo"].stringValue), placeholderImage: UIImage(named: "img_translucent"))
        cell.lbl_title.text = get_results[indexPath.row]["title"].stringValue
        cell.lbl_info.text = get_results[indexPath.row]["description"].stringValue

        let arr_kinds = get_results[indexPath.row]["main_options"].arrayValue
        let arr_costs = arr_kinds.map { ($0["cost"].stringValue) }
        let arr_str_kinds = arr_kinds.map { ($0["name"].stringValue) }
        let product_id = get_results[indexPath.row]["id"].intValue
        let get_ordered_prod = get_ordered_product(arr_kinds: arr_str_kinds, product_id: product_id)
        cell.arr_main_option = arr_str_kinds
        
        cell.lbl_count.text = String(get_ordered_prod["count"].intValue)

        //init sgm_kinds
        cell.sgm_kinds.items = arr_str_kinds
        cell.sgm_kinds.font = UIFont(name: "Helvetica", size: 13)
        cell.sgm_kinds.borderColor = Helper().UIColorFromRGB(rgbValue: UInt(SECOND_COLOR))
        let index_main_option = get_ordered_prod["main_option"].intValue
        cell.sgm_kinds.selectedIndex = index_main_option //0
        cell.product_id = product_id
        cell.btn_plus.tag = product_id
        cell.btn_minus.tag = product_id
        cell.btn_additional.tag = indexPath.row
        cell.btn_title.tag = indexPath.row
        cell.arr_cost_kinds = arr_costs
        cell.lbl_cost.text = CURRENCY + arr_costs[index_main_option]
        cell.lbl_delivery = self.view.viewWithTag(1000000000) as? UILabel
        cell.lbl_order_cost = self.view.viewWithTag(2000000000) as? UILabel
        return cell
    }
    
    func get_choosen_products(product_id: Int, main_option: String) -> Int
    {
        for prod in DBHelper().count_product_in_order(be_product_id: product_id)
        {
            if prod["main_option"].stringValue == main_option
            {
                return prod["count"].intValue
            }
        }
        return 0
    }
    
    func get_ordered_product(arr_kinds: [String], product_id: Int) -> JSON
    {
        for (index, kind) in arr_kinds.enumerated()
        {
            let count = get_choosen_products(product_id: product_id, main_option: kind)
            if count > 0
            {
                return ["main_option" : index, "count": count ]
            }
        }
        return ["main_option" : 0, "count": 0 ]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
    }
    
    @IBAction func on_clicked_btn_additional(_ sender: UIButton) {
        let controller : AdditionalViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalViewController") as! AdditionalViewController
        controller.arr_additionals = get_results[sender.tag]["additional_info"].arrayValue
        controller.product_id = get_results[sender.tag]["id"].intValue
        
        let arr_kinds = get_results[sender.tag]["main_options"].arrayValue
        let arr_str_kinds = arr_kinds.map { ($0["name"].stringValue) }
        if Main_option == ""
        {
            Main_option = arr_str_kinds[get_ordered_product(arr_kinds: arr_str_kinds, product_id:  get_results[sender.tag]["id"].intValue)["main_option"].intValue]
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func on_clicked_btn_title(_ sender: UIButton) {
        let modalViewController = ProductInfoViewController()
        modalViewController.modalPresentationStyle = .overFullScreen
        modalViewController.info = get_results[sender.tag]["description"].stringValue
        modalViewController.url_img_product = get_results[sender.tag]["photo"].stringValue
        modalViewController.title_product = get_results[sender.tag]["title"].stringValue
        self.present(modalViewController, animated: true, completion: nil)
    }

    @objc func update_header_costs()
    {
        set_order_cost()
        check_free_delivery()
    }
    
    func set_order_cost()
    {
        let lbl_order = self.view.viewWithTag(2000000000) as? UILabel
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
        let lbl_delivery = self.view.viewWithTag(1000000000) as? UILabel
        lbl_delivery?.text = check_delivery_cost()
        Total_delivery_cost = Int((lbl_delivery?.text?.replacingOccurrences(of: CURRENCY, with: ""))!)!
    }
    
}


class RequestManagerProducts {
    
    var getResults = [JSON]()
    func get(id: Int)
    {
        let url = SERVER_NAME + "/api/products?company_id=" + String(COMPANY_ID) + "&category_id=" + String(id)
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            if let results = response.result.value as? [String : Any] {
                    self.getResults = []
                let item = JSON(results["products"] as Any).arrayValue
                    self.getResults += item
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "get_result_product_updated"), object: nil)
                }
        }
    }
    
    func resetGet() {
        getResults = []
    }
}
