//
//  AddressRow.swift
//  DeliveryFood
//
//  Created by Admin on 29/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Eureka

//public class AddressCell: CustomDetailCell {
//
//}

public final class AddressRow: Row<CustomDetailCell>, SelectableRowType, RowType, CustomDetailCellProtocol {
    public var isListItem: Bool {return selectableValue != nil}
    
    
    public var textForEmpty: String? {return "Добавьте адрес"}
    
    //public var onDetailButtonTapped: ((AddressCell, AddressRow) -> ())?
    
    
    public var selectableValue: Address? {
        didSet {
            //title = selectableValue?.name
            cell.textLabel?.text = selectableValue?.name?.lowercased()
            cell.detailTextLabel?.text = selectableValue?.getAddressString()
            let button = UIButton(type: .infoLight)
            button.addTarget(self, action: #selector(didDetailButtonClick), for: .touchUpInside)
            cell.accessoryView = button
            
        }
    }
    
    //simple row
    override public var value: Address? {
        didSet {
            if selectableValue == nil {
                cell.textLabel?.text = value?.name?.lowercased()
                cell.detailTextLabel?.text = value?.getAddressString()
                cell.accessoryType = .disclosureIndicator
            }
        }
    }
    
    private var callBackOnDetailButtonTapped:((AddressRow)->Void)?
    public func onDetailButtonTapped(_ callback: @escaping (AddressRow) -> Void) -> Self {
        callBackOnDetailButtonTapped = callback
        return self
    }
    @objc func didDetailButtonClick(_ sender: UIButton) {
        callBackOnDetailButtonTapped?(self)
    }
    
    
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CustomDetailCell>(nibName: "CustomDetailCell")
        cell.detailTextLabel?.textColor = cell.defaultTextColor
        
        title = selectableValue?.name
        cell.detailTextLabel?.text = selectableValue?.getAddressString()
    }
}
