//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//

import UIKit

@IBDesignable public class FloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var title = UILabel()
	
	// MARK:- Properties
	override public var accessibilityLabel:String! {
		get {
			if text?.isEmpty ?? true {
				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	
	override public var placeholder:String? {
		didSet {
            if titleText == nil {
                title.text = placeholder
                title.sizeToFit()
            }
		}
	}
	
	override public var attributedPlaceholder:NSAttributedString? {
		didSet {
            if titleText == nil {
                title.text = attributedPlaceholder?.string
                title.sizeToFit()
            }
		}
	}
	
	@IBInspectable var titleFont: UIFont = .systemFont(ofSize: 13.0) {
		didSet {
            title.font = titleFont
            if isFirstResponder {
                title.font = titleFont.with(traits: .traitBold)
            }
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
    @IBInspectable var titleText:String? {
        didSet {
            title.text = titleText
            title.sizeToFit()
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = .gray {
		didSet {
			if !isFirstResponder {
				title.textColor = titleTextColour
			}
		}
	}
    
    private var _titleActiveTextColour:UIColor?
    
	@IBInspectable var titleActiveTextColour:UIColor? {
		set {
            _titleActiveTextColour = newValue
			if isFirstResponder {
				title.textColor = _titleActiveTextColour
			}
		}
        get {
            return _titleActiveTextColour ?? tintColor
        }
	}
	
	// MARK:- Init
	required public init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
	override public func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder
		if isResp && !(text?.isEmpty ?? true) {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
		}
		// Should we show or hide the title label?
		if text?.isEmpty ?? true {
			// Hide
			hideTitle(isResp)
		} else {
			// Show
			showTitle(isResp)
		}
	}
	
    override public var intrinsicContentSize: CGSize {
        //preferred content size, calculate it if some internal state changes
        return CGSize(width: 300, height: 38)
    }
    
	override public func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if !(text?.isEmpty ?? true){
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override public func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
		if !(text?.isEmpty ?? true) {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override public func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if !(text?.isEmpty ?? true) {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	private func setup() {
		borderStyle = UITextBorderStyle.none
        		//titleActiveTextColour = tintColor
		// Set up title label
        if textColor == nil { textColor = UIColor(white: 0.2, alpha: 1)}
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		if let str = placeholder, !str.isEmpty {
            title.text = str
            title.sizeToFit()
		}
		self.addSubview(title)
	}

	private func maxTopInset()->CGFloat {
		return max(0, floor(bounds.size.height - (font?.lineHeight ?? 0) - 4.0))
	}
	
	private func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		var x = r.origin.x
		if textAlignment == .center {
			x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
		} else if textAlignment == .right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
	}
	
	private func showTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.beginFromCurrentState.union(.curveEaseOut), animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			})
	}
	
	private func hideTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.beginFromCurrentState.union(.curveEaseIn), animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			})
	}
}

//temp
extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
} // extension

