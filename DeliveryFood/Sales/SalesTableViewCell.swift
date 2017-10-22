//
//  SalesTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 03.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SalesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_sale: UIImageView!
    @IBOutlet weak var txt_sale: UILabel!
    @IBOutlet weak var stp_count: UIStepper!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var sgm_kind: UISegmentedControl!
    @IBOutlet weak var lbl_cost_img: UILabel!
    @IBOutlet weak var btn_additional: UIButton!
    
    var old_value = 0
    var additional = [String(), Int()] as [Any]
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    @IBAction func on_clicked_stp_count(_ sender: UIStepper) {
        sender.maximumValue = 30
        sender.minimumValue = 0
        lbl_count.text = String(Int(sender.value))

        let rootViewController = self.window?.rootViewController as! UITabBarController!
        let tabArray = rootViewController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 2) as! UITabBarItem
        
        if old_value <= Int(sender.value)
        {
            if let badgeValue = tabItem.badgeValue {
                tabItem.badgeValue = String((Int(badgeValue) ?? 0) + 1)
            } else {
                tabItem.badgeValue = "1"
            }
        }
        else
        {
            if let badgeValue = tabItem.badgeValue {
                tabItem.badgeValue = String((Int(badgeValue) ?? 0) - 1)
            } else {
                tabItem.badgeValue = "0"
            }
        }
        old_value = Int(sender.value)
    }

}


class Sale {
    var cell_img_sale: String = ""
    var cell_txt_sale: String = ""
    var cell_btn_cost: Int = 0
    var id: Int = 0
}

extension Sale {
    
    static func transformSale(saleDictionary: [String: Any]) -> Sale {
        let sale = Sale()
        
        sale.id = (saleDictionary["id"] as? Int)!
        sale.cell_img_sale = (saleDictionary["image_url"] as? String)!
        sale.cell_txt_sale = (saleDictionary["title_sale"] as? String)!
        sale.cell_btn_cost = (saleDictionary["cost"] as? Int)!
        
        return sale
    }
    
}


