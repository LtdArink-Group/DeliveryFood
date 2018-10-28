//
//  Order.swift
//  DeliveryFood
//
//  Created by Admin on 24/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class Order {
    var summaNetto: Double!
    
    var productDictionary:[[String:Any]] = []
    

}

//MARK: for testing

//MARK: dummy
extension Order {
    func fillByDummy() -> Self {
        summaNetto = 533
        productDictionary = [["product_id": 260, "ingredients": [], "qty": 1, "main_option": "400 гр"], ["product_id": 265, "ingredients": [], "qty": 2, "main_option": "488 гр"]]
        
        return self
    }
}
