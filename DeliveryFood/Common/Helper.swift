//
//  Helper.swift
//  DeliveryFood
//
//  Created by B0Dim on 03.10.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit

class Helper {

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func increment_label(from_value: Int, end_value: Int, label: UILabel)
    {
        let duration: Double = 1.0
        DispatchQueue.global().async {
            if from_value < end_value
            {
                for i in from_value ..< (end_value + 1) {
                    let sleepTime = UInt32(duration/Double(end_value) * 100000.0)
                    usleep(sleepTime)
                    DispatchQueue.main.async {
                        label.text = CURRENCY + "\(i)"
                    }
                }
            }
            else
            {
                var from = from_value
                while end_value < from
                {
                    from = from > 0 ? from - 1 : 0
                    let sleepTime = from == 0 ? UInt32(0) : UInt32(duration/Double(from) * 100000.0)
                    usleep(sleepTime)
                    DispatchQueue.main.async {
                        label.text = CURRENCY + "\(from)"
                    }
                }
            }
        }
    }
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }


    //MARK: on_clicked
}
