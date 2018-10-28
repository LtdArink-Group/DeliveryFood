//
//  Utililtis.swift
//  DeliveryFood
//
//  Created by Admin on 04/08/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import UIKit
import Foundation

class Utils {
    static let shared = Utils()
    
    private init() {}
    
    //for tests
    init(phoneId: String) {
        phoneId_ = phoneId
        type(of: self).shared.phoneId_ = phoneId
    }
    
    func isDebugMode() -> Bool {
        var isDebug: Bool = false
        assert({ isDebug = true; return true }())
        
        return isDebug
    }
    
    func isTestApp() -> Bool {
        let bundleID = Bundle.main.bundleIdentifier
        let isDemo = bundleID != nil && (bundleID!.range(of: "DEBUG") != nil || bundleID!.range(of: "demo") != nil)
        
        return isDebugMode() || isDemo
    }
    
    private var phoneId_: String?  = nil
    var phoneId: String {
        get {
            if (phoneId_ == nil || phoneId_!.isEmpty) {
                phoneId_ = !isDebugMode() || true ? UIDevice.current.identifierForVendor!.uuidString : "00000000-0000-4265-97CA-000000000011"
            }
            return phoneId_ ?? ""
        }
    }
}

