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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        preload_form()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preload_form()
    }
    
    func preload_form()
    {
        self.navigationItem.setHidesBackButton(true, animated:true)

        let arr_orders = [["address": "Ленинградская 46 - оф. 605", "title_address": "работа", "date": "08.10.2017", "time": "15-00", "cost": "1700", "id": "1"],
                          ["address": "Уборевича 42а - кв. 47", "title_address": "дом", "date": "10.10.2017", "time": "20-00", "cost": "1200", "id": "2"],
                          ["address": "Ленина 46 - кв. 51", "title_address": "любовница", "date": "12.10.2017", "time": "21-00", "cost": "2500", "id": "3"]]
        if self.tabBarController?.tabBar.items?[2].badgeValue == nil || self.tabBarController?.tabBar.items?[2].badgeValue == "0"
        {
            if form.isEmpty == true
            {
                create_form(arr_orders: arr_orders)
            }
        }
        else
        {
            navigationController?.popViewController(animated: false)
        }
    }

    func create_form(arr_orders: [[String: String]])
    {
        form
            +++ Section("Предыдущие заказы") {on in
                on.header?.height = {33}
                for (index, each) in arr_orders.enumerated()
                {
                    on <<< LabelRow() {
                        $0.cell.backgroundColor = index % 2 != 0 ? Helper().UIColorFromRGB(rgbValue: 0xCEF8B6) : .white
                        $0.title = each["address"]! + " (" + each["title_address"]! + ")" + "\n"
                            + each["date"]! + " в " + each["time"]! + " - " + CURRENCY + " " + each["cost"]!
                        $0.cell.textLabel?.font = UIFont(name: "Helvetica", size: 13)
                        $0.cell.textLabel?.numberOfLines = 2
                        $0.cell.accessoryType = .disclosureIndicator
                        }.onCellSelection {row,cell in
                            self.go_to_order(id: Int(each["id"]!)!)
                    }
                }
        }
    }
    
    func go_to_order(id: Int)
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
