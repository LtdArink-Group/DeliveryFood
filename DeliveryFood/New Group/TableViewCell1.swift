//
//  TableViewCell1.swift
//  DeliveryFood
//
//  Created by B0Dim on 15.12.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var img_cell: UIImageView!
    @IBOutlet weak var lbl_cost: UILabel!
    @IBOutlet weak var btn_title: UIButton!
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var btn_additional: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
