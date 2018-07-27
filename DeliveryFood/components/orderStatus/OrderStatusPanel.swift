//
//  OrderStatusPanel.swift
//  tabApp
//
//  Created by Admin on 22/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class OrderStatusPanel: UIView {

    @IBOutlet weak var deliveryCostButton: OrderStatusButton!
    @IBOutlet weak var orderCostButton: OrderStatusButton!
    @IBOutlet weak var phoneButton: OrderStatusButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    
    func initView() {
        _ = self.addViewFromNib()
    }
    
    var totalCostText: String? {
        get {
            return orderCostButton.sumLabel.text
        }
        set(totalCostText) {
            orderCostButton.sumLabel.text = totalCostText
        }
    }
    
    var totalCost: Int {
        get {
            return Int(orderCostButton.summaValue)
        }
        set(value) {
            orderCostButton.summaValue = CGFloat(value)
        }
    }

    var deliveryCost: Int {
        get {
            return Int(deliveryCostButton.summaValue)
        }
        set(value) {
            deliveryCostButton.summaValue = CGFloat(value)
        }
    }
    
    var productCount: Int {
        get {
            return Int(orderCostButton.badgeValue)
        }
        set(value) {
            orderCostButton.badgeValue = CGFloat(value)
        }
    }


    @IBAction func onClickOrderButton(_ sender: Any) {
        let newViewController = self.parentViewController?.storyboard?.instantiateViewController(withIdentifier: "NewOrderViewController") as! NewOrderViewController
        self.parentViewController?.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func onClickCallButton(_ sender: Any) {
        Header().on_clicked_call(sender: sender as! UIButton)
    }
}

