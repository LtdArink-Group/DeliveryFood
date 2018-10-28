//
//  FloatLabelCells.swift
//  DeliveryFood
//
//  Created by Admin on 26/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Eureka

//MARK: FloatLabelCell

public class _FloatLabelCell<T>: Cell<T>, UITextFieldDelegate, TextFieldCell where T: Equatable, T: InputTypeInitiable {
    
    public var textField: UITextField! { return floatLabelTextField }
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy public var floatLabelTextField: FloatLabelTextField = { [unowned self] in
        let floatTextField = FloatLabelTextField()
        floatTextField.translatesAutoresizingMaskIntoConstraints = false
        floatTextField.font = .preferredFont(forTextStyle: .body)
        floatTextField.titleFont = .preferredFont(forTextStyle: .caption1) //.boldSystemFont(ofSize: 13.0)
        floatTextField.clearButtonMode = .never
        floatTextField.titleText = row.title
        
        return floatTextField
        }()
    
    
    open override func setup() {
        super.setup()
        selectionStyle = .none
        contentView.addSubview(floatLabelTextField)
        floatLabelTextField.delegate = self
        floatLabelTextField.addTarget(self, action: #selector(_FloatLabelCell.textFieldDidChange(_:)), for: .editingChanged)
        contentView.addConstraints(layoutConstraints())
    }
    
    open override func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        if let placeholder = (row as? FloatFieldRowConformance)?.placeholder {
            let color = (row as? FloatFieldRowConformance)?.placeholderColor
            
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: color ?? .lightGray])

        }
        //floatLabelTextField.titleActiveTextColour = tintColor
        floatLabelTextField.text =  row.displayValueFor?(row.value)
        floatLabelTextField.titleTextColour = row.isValid ? .lightGray : .red
        floatLabelTextField.titleFont = floatLabelTextField.titleFont
        floatLabelTextField.isEnabled = !row.isDisabled
        floatLabelTextField.alpha = row.isDisabled ? 0.6 : 1
    }
    
    open override func cellCanBecomeFirstResponder() -> Bool {
        return !row.isDisabled && floatLabelTextField.canBecomeFirstResponder
    }
    
    open override func cellBecomeFirstResponder(withDirection direction: Direction) -> Bool {
        return floatLabelTextField.becomeFirstResponder()
    }
    
    open override func cellResignFirstResponder() -> Bool {
        return floatLabelTextField.resignFirstResponder()
    }
    
    private func layoutConstraints() -> [NSLayoutConstraint] {
        let views = ["floatLabeledTextField": floatLabelTextField]
        let metrics = ["vMargin":8.0]
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-[floatLabeledTextField]-|", options: .alignAllLastBaseline, metrics: metrics, views: views)
            //+ NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|", options: .alignAllLastBaseline, metrics: metrics, views: views)
    }
    
    @objc public func textFieldDidChange(_ textField : UITextField){
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
        if let fieldRow = row as? FormatterConformance, let formatter = fieldRow.formatter {
            if fieldRow.useFormatterDuringInput {
                let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.allocate(capacity: 1))
                let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?>? = nil
                if formatter.getObjectValue(value, for: textValue, errorDescription: errorDesc) {
                    row.value = value.pointee as? T
                    if var selStartPos = textField.selectedTextRange?.start {
                        let oldVal = textField.text
                        textField.text = row.displayValueFor?(row.value)
                        if let f = formatter as? FormatterProtocol {
                            selStartPos = f.getNewPosition(forPosition: selStartPos, inTextInput: textField, oldValue: oldVal, newValue: textField.text)
                        }
                        textField.selectedTextRange = textField.textRange(from: selStartPos, to: selStartPos)
                    }
                    return
                }
            }
            else {
                let value: AutoreleasingUnsafeMutablePointer<AnyObject?> = AutoreleasingUnsafeMutablePointer<AnyObject?>.init(UnsafeMutablePointer<T>.allocate(capacity: 1))
                let errorDesc: AutoreleasingUnsafeMutablePointer<NSString?>? = nil
                if formatter.getObjectValue(value, for: textValue, errorDescription: errorDesc) {
                    row.value = value.pointee as? T
                }
                return
            }
        }
        guard !textValue.isEmpty else {
            row.value = nil
            return
        }
        guard let newValue = T.init(string: textValue) else {
            return
        }
        row.value = newValue
    }
    
    
    //Mark: Helpers
    
    private func displayValue(useFormatter: Bool) -> String? {
        guard let v = row.value else { return nil }
        if let formatter = (row as? FormatterConformance)?.formatter, useFormatter {
            return textField?.isFirstResponder == true ? formatter.editingString(for: v) : formatter.string(for: v)
        }
        return String(describing: v)
    }
    
    //MARK: TextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        formViewController()?.beginEditing(of: self)
        if let fieldRowConformance = row as? FormatterConformance, let _ = fieldRowConformance.formatter, fieldRowConformance.useFormatterOnDidBeginEditing ?? fieldRowConformance.useFormatterDuringInput {
            textField.text = displayValue(useFormatter: true)
        } else {
            textField.text = displayValue(useFormatter: false)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        formViewController()?.endEditing(of: self)
        formViewController()?.textInputDidEndEditing(textField, cell: self)
        textFieldDidChange(textField)
        textField.text = displayValue(useFormatter: (row as? FormatterConformance)?.formatter != nil)
    }
}

@IBDesignable public class TextFloatLabelCell : _FloatLabelCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        super.setup()
        textField?.autocorrectionType = .default
        textField?.autocapitalizationType = .sentences
        textField?.keyboardType = .default
    }
}

public class PhoneFloatLabelCell : TextFloatLabelCell {
    
    public override func setup() {
        super.setup()
        textField?.keyboardType = .phonePad
    }
    
}

public class NameFloatLabelCell : TextFloatLabelCell {
   
    public override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.keyboardType = .default
    }
}

public class EmailFloatLabelCell : TextFloatLabelCell{
    
    public override func setup() {
        super.setup()
        textField?.autocorrectionType = .no
        textField?.autocapitalizationType = .none
        textField?.keyboardType = .emailAddress
    }
}

//MARK: FloatLabelRow
public protocol FloatFieldRowConformance: class {
    var placeholder : String? { get set }
    var placeholderColor : UIColor? { get set }
}

open class FloatFieldRow<Cell: CellType>: FormatteableRow<Cell>, FloatFieldRowConformance where Cell: BaseCell, Cell: TextFieldCell {
    
    /// The placeholder for the textField
    open var placeholder: String?
    
    /// The textColor for the textField's placeholder
    open var placeholderColor: UIColor?
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
}

public final class TextFloatLabelRow: FloatFieldRow<TextFloatLabelCell>, RowType {

    public required init(tag: String?) {
        super.init(tag: tag)

    }
}

public final class NameFloatLabelRow: FloatFieldRow<NameFloatLabelCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
}
public final class EmailFloatLabelRow: FloatFieldRow<EmailFloatLabelCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}
public final class PhoneFloatLabelRow: FloatFieldRow<PhoneFloatLabelCell>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        
        add(rule: RuleRegExp.phoneRule())
        initOnRowValidationChanged()
        
        onCellHighlightChanged { cell, row in
            if row.isHighlighted && (row.value == nil || (row.value?.isEmpty)!) {
                row.value = "+7"
            }
        }
    }
}


//MARK: - Validation
fileprivate final class ErrorLabelRow: _LabelRow, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cell.textLabel?.textColor = .red
        cell.textLabel?.font = UIFont.systemFont(ofSize: 11)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 3
        

        cellUpdate({ (cell, row) in
            cell.textLabel?.textColor = .red
            cell.height = { ((cell.textLabel?.frame.size.height)! + 2)}
        })
    }
}

fileprivate extension RowType where Self: BaseRow {
    func initOnRowValidationChanged() {
        validationOptions = .validatesOnBlur
        onRowValidationChanged {(cell, row) in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is ErrorLabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = ErrorLabelRow() {
                        $0.title = validationMsg
                        }
                    
                    row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                }
            }
        }
        cellUpdate { (cell, row) in
            if !row.isValid  {
                (cell as! TextFloatLabelCell).floatLabelTextField.title.textColor = .red
            }
        }
    }
}


extension RuleRegExp {
    class func phoneRule() -> RuleRegExp {
        return RuleRegExp(regExpr: "^\\+7[94]\\d{9}$", allowsEmpty: true, msg: "Телефон должен иметь международный формат (начинаться с +7, далее 9 или 4 и только цифры)")
    }
}
