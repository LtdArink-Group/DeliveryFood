//
//  CostCalculator.swift
//  DeliveryFood
//
//  Created by Admin on 10/10/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import Foundation

class CostCalculator {
    
    static func getDeliverCost(forOrderCost orderCost: Int, forPickup pickup: Bool = false) -> Int {
        return orderCost >= COST_FREE_DELIVERY || pickup ? 0 : COST_DELIVERY
    }
    
    static func getTotalCostWith(orderCost: Int, pickup:Bool) -> Int {
        let delivertyCost = getDeliverCost(forOrderCost: orderCost, forPickup: pickup)
        let deliveryDiscount = pickup ? DELIVERY_DISCONT : 0
        
        return orderCost * (100 - deliveryDiscount)/100 + delivertyCost
    }
    
    static func isExistDiscount(forPickup pickup: Bool) -> Bool {
        return pickup && DELIVERY_DISCONT > 0
    }
}
