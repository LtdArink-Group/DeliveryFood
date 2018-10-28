//
//  AddressCell.swift
//  DeliveryFood
//
//  Created by Admin on 27/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Eureka

//todo refine to generic class, now eureka gives error on loading nib
public class CustomDetailCell: Cell<Address>, CellType {
	
    @IBOutlet private weak var textLabel_: BadgeSwift!
    @IBOutlet private weak var detailTextLabel_: UILabel!
    
    @IBOutlet weak var offsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailOffsetConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailConstraintY: NSLayoutConstraint!
    
    
    override public var textLabel: UILabel? {
        get {return self.textLabel_}
    }
    override public var detailTextLabel: UILabel? {
        get {return self.detailTextLabel_}
    }
    
    /// Image for selected state
    lazy public var trueImage: UIImage = {
        return UIImage(named: "checkmark")!
    }()
    
    /// Image for unselected state
    lazy public var falseImage: UIImage? = {
        return nil
    }()
    
    var verticalDetailOffset: CGFloat = 0.0
    var initialTextColor: UIColor?
    
    public override func setup() {
        accessoryType = .none
        super.setup()
        height = {return 54}
    }
    
    public override func update() {
        //super.update()
        
        let isEmpty = (detailTextLabel_.text ?? "").isEmpty || detailTextLabel_.text == (row as? CustomDetailCellProtocol)?.textForEmpty
        
        if isEmpty {
            detailTextLabel?.text = (row as? CustomDetailCellProtocol)?.textForEmpty
        }
        if initialTextColor == nil {initialTextColor = detailTextLabel_.textColor}
        detailTextLabel?.textColor = isEmpty ? .lightGray : initialTextColor
        
        
        let isSelected = (row.value != nil)
        
        textLabel_.badgeColor = (isSelected && row.title == nil ? tintColor : UIColor.white)!
        textLabel_.textColor = isSelected && row.title == nil ? UIColor.white : detailTextLabel?.textColor
        if row.title != nil && !isEmpty {
            textLabel?.text = row.title
            textLabel?.font = .preferredFont(forTextStyle: .caption1)
            textLabel?.textColor = .lightGray
            textLabel_.insets = CGSize(width: 0, height: 0)
        }
        textLabel_.isHidden = (textLabel_?.text ?? "").isEmpty || isEmpty;
        if verticalDetailOffset == 0 {verticalDetailOffset = detailConstraintY?.constant ?? 0}
        detailConstraintY.constant = textLabel_.isHidden  ? 0.0 : verticalDetailOffset
        

        if (row as? CustomDetailCellProtocol)?.isListItem ?? true {
            checkImageView?.image = isSelected ? trueImage : falseImage
            checkImageView?.image = checkImageView?.image?.withRenderingMode(.alwaysTemplate)
            checkImageView?.tintColor = tintColor
            checkImageView?.sizeToFit()
            detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
        } else {
            offsetConstraint.constant = 0
            trailOffsetConstraint.constant = 0
        }

    }
    
    
    /// Image view to render images. If `accessoryType` is set to `checkmark`
    /// will create a new `UIImageView` and set it as `accessoryView`.
    /// Otherwise returns `self.imageView`.
    open var checkImageView: UIImageView? {
        guard accessoryType == .checkmark else {
            return self.imageView
        }
        
        guard let accessoryView = accessoryView else {
            let imageView = UIImageView()
            self.accessoryView = imageView
            return imageView
        }
        
        return accessoryView as? UIImageView
    }
    
    
    public override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }
    
}

public protocol CustomDetailCellProtocol {
    var textForEmpty: String? {get}
    var isListItem: Bool {get}
}

