//
//  PickupCell.swift
//  DeliveryFood
//
//  Created by Admin on 09/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Eureka

public class PickupCell: Cell<Bool>, CellType {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var discountImage: UIImageView!
    @IBOutlet weak var discountLabel: UILabel!
    
    public override func setup() {
        super.setup()
        

        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
        
        
        discountImage?.image = discountImage?.image?.withRenderingMode(.alwaysTemplate)

    }
    
    public override func update() {
        super.update()
        let discountValue = (row as! PickupCellProtocol).discountValue ?? 0
        
        height = {return discountValue > 0 ? 70 : 44}
        discountImage.isHidden = discountValue == 0
        discountLabel.text = discountValue > 0 ? String(format: "%d%%", discountValue): nil
        //todo change applying SECOND_COLOR
        discountImage?.tintColor = row.value ?? false ? Helper.shared.UIColorFromRGB(rgbValue: UInt(SECOND_COLOR)): UIColor(white: 0.9, alpha: 1)
    }
    
    
    
    //MARK: helper
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        row.value = segment.selectedSegmentIndex == 1
        row.updateCell()

    }
    
}

public protocol PickupCellProtocol {
    var discountValue: Int? {get set}
}

public final class PickupRow: Row<PickupCell>, RowType, PickupCellProtocol {
    
    private var discountValue_: Int?
    public var discountValue: Int? {
        get {
            return discountValue_
        }
        set {
            discountValue_ = newValue
        }
    }
    
    override public var value: Bool? {
        didSet {
            cell.segmentControl.selectedSegmentIndex = value ?? false ? 1 : 0
        }
    }
    
    
    
    required public init(tag: String?) {
        super.init(tag: tag)

        cellProvider = CellProvider<PickupCell>(nibName: "PickupCell")

    }
}

