//
//  DeliveryModel.swift
//  DeliveryFood
//
//  Created by Admin on 24/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//
import Foundation
import SwiftyJSON

class Delivery:Model {
    
    var account: Account!
    var pickup: Bool = false
    var note: String?
    var time: Date?
    
    var order: Order!
    var address: Address?
    
    init(order: Order) {
        super.init()
      
        if let _account = PerssistData.shared.data["\(type(of: account))"] as? Account  {
            account = _account
        } 
        self.order = order
    }
    
    required init(json: JSON) {
        fatalError("init(json:) has not been implemented")
    }
    
    
    override func toDictionary() -> [String: Any] {
        var params = Dictionary<String, Any>()
        params["address_id"] = address?.id
        params["order_products"] = order.productDictionary.count > 0 ? order.productDictionary : nil
        params["delivery_time"] = timeToString()
        params["pickup"] = pickup
        params["note"] = note
        return params
    }


    //MARK: local helper
    func timeToString() -> String?
    {
        guard time != nil else {return nil}
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: time!) + Config.ApiDefaultValues.tzOffset
    }
}


//MARK: dumps
extension Delivery {
    func fillByDummy() -> Self {
        account = Account().fillByDummy()
        //address = Address().fillByDummy()
        
        //note = "без перца"
        return self
    }
}
