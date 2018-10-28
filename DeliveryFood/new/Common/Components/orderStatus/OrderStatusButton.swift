//
//  OrderStatusItemView.swift
//  DeliveryFood
//
//  Created by Admin on 19/07/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit


@IBDesignable class OrderStatusButton: UIButton {

    
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var badgeView: BadgeSwift!
    @IBOutlet weak var sumLabel: UILabel!
    
    var view: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initView()   
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
   
    
    func initView() {
        view = self.addViewFromNib()
        setColors()
        iconView.image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //badgeView.insets = CGSize(width: 0, height: 0)
    }
    
    func setColors() {
        sumLabel.textColor = tintColor
        captionLabel.textColor = tintColor;
    }
    
    @IBInspectable var caption: String? {
        get {
            return captionLabel.text
        }
        set(caption) {
            captionLabel.text = caption
        }
    }
    
    @IBInspectable var summaHidden: Bool = false {
        didSet{
            sumLabel.isHidden = summaHidden
        }
    }
    
    @IBInspectable var rightLineHidden: Bool = false {
        didSet{
            rightLine.isHidden = rightLineHidden
        }
    }
    
    @IBInspectable var hideBadgeIfZero: Bool = true
    
    @IBInspectable var summaValue: CGFloat = 0 {
        didSet{
             sumLabel.text = "₽ \(Int(summaValue))"
        }
    }
    
    @IBInspectable var badgeValue: CGFloat = 0 {
        didSet{
            badgeView.isHidden = badgeValue == 0 && hideBadgeIfZero;
            badgeView.text = "\(Int(badgeValue))"
        }
    }
    
    override var tintColor: UIColor! {
        didSet{
            setColors()
        }
    }
    
    @IBInspectable var image: UIImage? {
        get {
            return iconView.image
        }
        set(image) {
            iconView.image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        }
    }
    

//    func initSubviews() {
//        // standard initialization logic
//        let nib = UINib(nibName: "OrderStatusItemView", bundle: nil)
//        nib.instantiate(withOwner: nil, options: nil)
//        //contentView.frame = bounds
//        let but  = UIButton()
//        addSubview(but)
//        //contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        //ayer.masksToBounds = true
//
//
//    }
    
    
//    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
//        return self.loadFromNibIfEmbeddedInDifferentNib()
//    }
//
//      override func awakeFromNib() {
//        super.awakeFromNib()
//        layoutIfNeeded()
//        //setUp()
//      }
    override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                updateAppearance()
            }
        }
    }
    
    private func updateAppearance() {
        if (isSelected || isHighlighted) && isEnabled {
            buttonTouchedIn()
        } else {
            buttonTouchedOut()
        }
        alpha = isEnabled ? 1 : 0.8
    }

    private func buttonTouchedIn() {
        //backgroundColor = UIColor(red:1,green:1,blue:0,alpha:1) // as an example
        view.backgroundColor = UIColor(red:0.9,green:0.9,blue:0.9,alpha:1) // as an example
    }

    private func buttonTouchedOut() {
        //backgroundColor = UIColor(red:1,green:1,blue:1,alpha:1) // some old value (example)
        view.backgroundColor = UIColor(red:1,green:1,blue:1,alpha:1) // as an example
    }
  
    

}
