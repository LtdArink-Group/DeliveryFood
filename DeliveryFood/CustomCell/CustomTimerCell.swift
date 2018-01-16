//
//  CustomTimerCell.swift
//  DeliveryFood
//
//  Created by B0Dim on 16.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Eureka
import CountdownLabel

public class CustomTimerCell: Cell<Bool>, CellType {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_timer: CountdownLabel!
    @IBOutlet weak var lbl_state: UILabel!
    
    public override func setup() {
        super.setup()
        if UIScreen.main.bounds.size.width == 320
        {
            lbl_timer.font = UIFont(name: "Helvetica-Bold", size: 32)
        }
        lbl_timer.textColor = Helper().UIColorFromRGB(rgbValue: UInt(CUCCESS_COLOR))
        lbl_state.textColor = Helper().UIColorFromRGB(rgbValue: UInt(CUCCESS_COLOR))
    }
}
    
public final class CustomTimerRow: Row<CustomTimerCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // We set the cellProvider to load the .xib corresponding to our cell
        cellProvider = CellProvider<CustomTimerCell>(nibName: "CustomTimerCell")
    }
}

