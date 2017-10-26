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
    
    var arr_order_post_server: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arr_order_post_server = [
            [
                "product_id": 1,
                "qty": 1,
                "main_options": 2,
                "additional_options": [
                    ["id": 1, "qty": 1],
                    ["id" : 2, "qty": 2]
                ]
            ],
            [
                "product_id": 2,
                "qty": 2,
                "main_options": 1,
                "additional_options": [
                    ["id": 1, "qty": 1]
                ]
            ],
            [
                "product_id": 3,
                "qty": 3,
                "additional_options": []
            ],
        ]

        preload_form()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preload_form()
    }
    @IBAction func on_clicked_btn_remove_order(_ sender: UIBarButtonItem) {
        DBHelper().delete_order()
    }
    
    func preload_form()
    {
        if self.tabBarController?.tabBar.items?[2].badgeValue == nil || self.tabBarController?.tabBar.items?[2].badgeValue == "0"
        {
            go_to_old_order()
        }
        else
        {
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.rowHeight = 44
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            let height = bounds.size.height
            
            scrl_main.contentSize = CGSize(width: width, height: bounds.size.height)
            scrl_main.frame = CGRect(x: 0,y: 64,width: width,height: height)
            scrl_main.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func go_to_old_order()
    {
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
        return 1
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableViewCell
        return cell
    }
    

}
