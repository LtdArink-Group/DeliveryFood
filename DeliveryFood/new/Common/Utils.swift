//
//  Utililtis.swift
//  DeliveryFood
//
//  Created by Admin on 04/08/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import Foundation

class Utils {
    static let shared = Utils()
    
    
    func isDebugMode() -> Bool {
        var isDebug: Bool = false
        assert({ isDebug = true; return true }())
        
        let bundleID = Bundle.main.bundleIdentifier
        let isDebug2 = bundleID != nil && bundleID!.range(of: "DEBUG") != nil
        
        return isDebug && isDebug2
    }
    

}

