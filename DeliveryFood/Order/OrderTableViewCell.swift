//
//  OrderTableViewCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 16.10.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_cost: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func on_clicked_btn_plus(_ sender: UIButton) {
        
    }
    
    @IBAction func on_clicked_btn_minus(_ sender: UIButton) {
    }
    
    

}
