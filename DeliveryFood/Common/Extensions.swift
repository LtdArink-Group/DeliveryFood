//
//  Extensions.swift
//  DeliveryFood
//
//  Created by B0Dim on 27.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Foundation
import UIKit
import SQLite
import SQLite3

enum UILabelTextPositions : String {
    
    case VERTICAL_ALIGNMENT_TOP = "VerticalAlignmentTop"
    case VERTICAL_ALIGNMENT_MIDDLE = "VerticalAlignmentMiddle"
    case VERTICAL_ALIGNMENT_BOTTOM = "VerticalAlignmentBottom"
    
}

extension UILabel{
    func makeLabelTextPosition (sampleLabel :UILabel?, positionIdentifier : String) -> UILabel
    {
        let rect = sampleLabel!.textRect(forBounds: bounds, limitedToNumberOfLines: 0)
        switch positionIdentifier
        {
        case "VerticalAlignmentTop":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            break
            
        case "VerticalAlignmentMiddle":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2,
                                        width: rect.size.width, height: rect.size.height)
            break
        case "VerticalAlignmentBottom":
            sampleLabel!.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            break
        default:
            sampleLabel!.frame = bounds
            break
        }
        return sampleLabel!
    }
}


