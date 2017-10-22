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
    @IBOutlet weak var btn_cost_sale: UIButton!
    @IBOutlet weak var stp_count: UIStepper!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var sgm_kind: UISegmentedControl!
    
//    var sale: Sale? {
//        didSet {
//            updateView()
//        }
//    }
    
    var cell_img_sale: String = ""
    var cell_txt_sale: String = ""
    var cell_btn_cost: Int = 0
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update()
    {
        print("update")
//        print(cell_img_sale)
//        print(cell_btn_cost)
//        print(cell_txt_sale)
//        img_sale.sd_setImage(with: URL(string: cell_img_sale))
        img_sale.image = UIImage(named: cell_img_sale)
        txt_sale.text = String(describing: cell_txt_sale)
        lbl_count.text = "0"
        btn_cost_sale.titleLabel?.text = String(describing: cell_btn_cost)
        
    }

//    func updateView()
//    {
//        img_sale.image = UIImage(named: (sale?.cell_img_sale)!)
//        txt_sale.text = String(describing: sale?.cell_txt_sale)
//        lbl_count.text = "0"
//        btn_cost_sale.titleLabel?.text = String(describing: sale?.cell_btn_cost)
//    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
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

