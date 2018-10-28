//
//  String.swift
//  DeliveryFood
//
//  Created by Admin on 16/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
extension String {
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return self
        }
    }
    
    func isValid(regExp: String) -> Bool {
        
        let regex = try! NSRegularExpression(pattern: regExp, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
