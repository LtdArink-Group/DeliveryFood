//
//  AddressPartView.swift
//  DeliveryFood
//
//  Created by Admin on 03/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

@IBDesignable class TextFieldWithLabelBelow: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var editField: UITextField!
    
    @IBOutlet weak var labelField: UILabel!
    
    @IBOutlet weak var labelBackgroundView: UIView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelField.textColor = tintColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        labelField.textColor = UIColor.lightGray
    }
    
    func initView() {
        _ = self.addViewFromNib()
        editField.text = nil
        labelField.text = nil
        
        editField.delegate = self
        

        
        
    }
    
    @IBInspectable var text: String? {
        get {
            return editField.text
        }
        set {
            editField.text = newValue
        }
    }
    
    @IBInspectable var labelText: String? {
        get {
            return labelField.text
        }
        set {
            labelField.text = newValue
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 0.5
        layer.cornerRadius = 6
        layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.75)
        //labelBackgroundView.backgroundColor = tintColor
        
    }
    

}
