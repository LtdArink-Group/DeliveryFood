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
        PageLoading().hideLoading()
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

}

class DeliveryInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/4)
        let width = UIScreen.main.bounds.width
        let imageView = UIImageView(image: UIImage(named: "img_header2"))
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width/4)
        addSubview(imageView)
        
        let lbl_delivery = UILabel(frame: CGRect(x: 0, y: width/6.5, width: width/3, height: 30))
        lbl_delivery.textAlignment = NSTextAlignment.center
        lbl_delivery.font = UIFont(name: "Helvetica", size: 17)
        lbl_delivery.text = CURRENCY +  " " + String(COST_DELIVERY)
        lbl_delivery.tag = 1
        addSubview(lbl_delivery)

        let lbl_order = UILabel(frame: CGRect(x: width/3, y: width/6.5, width: width/3, height: 30))
        lbl_order.textAlignment = NSTextAlignment.center
        lbl_order.font = UIFont(name: "Helvetica", size: 17)
        lbl_order.text = CURRENCY +  " " + String(COST_ORDER_DEFAULT)
        lbl_order.tag = 2
        addSubview(lbl_order)
        
        let btn_call = UIButton(type: UIButtonType.custom) as UIButton
        btn_call.frame = CGRect(x: (width/3) * 2, y: 0, width: width/3, height: width/4)
        btn_call.addTarget(self, action: #selector(DeliveryInfoView.on_clicked_call(sender:)), for: UIControlEvents.touchUpInside)
        addSubview(btn_call)
    }
    
    @objc func on_clicked_call(sender: UIButton!)
    {
        let phone:NSURL = NSURL(string: "tel://\(PHONE)")!
        UIApplication.shared.openURL(phone as URL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
