//
//  Model.swift
//  DeliveryFood
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Model:JSONApiAble, Equatable {
  
    var isNew: Bool {return json == nil}
    var isModificated: Bool {return self.isNew || self != type(of: self).init(json: self.json!)}
    private var json: JSON?
    
    init() {}
    
    required public init(json: JSON) {
        self.json = json
    }
   
    func toDictionary() -> [String: Any] {
        fatalError("init(json:) has not been implemented")
    }
    
    public static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.equals(rhs: rhs)
    }
    
    func equals(rhs: Model) -> Bool {
        fatalError("== has not been implemented")
    }

    
    //MARK: Helpers
    func emptyToNil(_ value: String?) -> String? {
        return value != nil && value!.isEmpty ? nil : value
    }
}
