//
//  Profile.swift
//  DeliveryFood
//
//  Created by Admin on 10/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account:Model {
   
    var phone: String!
    var name: String?
    var email: String?

    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
        phone = (json["phone"].string ?? "").removingRegexMatches(pattern: "^7", replaceWith: "+7")
        name = emptyToNil(json["name"].string)
        email = emptyToNil(json["email"].string)
    }
    

    override func toDictionary() -> [String: Any] {
        return ["phone": phone ?? "", "name": name ?? "", "email": email ?? ""]
    }
    
    override func equals(rhs _rhs: Model) -> Bool {
        let lhs = self
        let rhs = _rhs as! Account
        return
            lhs.phone == rhs.phone &&
                lhs.email == rhs.email &&
                lhs.name == rhs.name;
    }

}


//MARK: dummy
extension Account {
    func fillByDummy() -> Self {
        phone = "+79993334455"
        name = "Неименовий"
        
        return self
    }
}
