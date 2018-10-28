//
//  PerssistData.swift
//  DeliveryFood
//
//  Created by Admin on 16/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class PerssistData {
    static let shared = PerssistData()
    
    var data:[String: AnyObject] = Dictionary<String, AnyObject>()
    
    private init() {
        
    }

    
    
}
