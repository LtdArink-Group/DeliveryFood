//
//  CreateOrderViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
import Fabric

class CreateOrderViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
    }
    
    func post_order(address_id: Int)
    {
        //Company_id: Constants
        //ID_phone: Global
        //id_address: get_from
        //order_products: JSON
    }

    func delete_order_sqlite()
    {
        DBHelper().delete_order()
    }
    
}
