//
//  APIDelivery.swift
//  DeliveryFood
//
//  Created by Admin on 06/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class APIDelivery: APIBase {
    var url:String {return APIBase.baseUrl + "/api/orders"}
    //var accountId: String = Utils.shared.phoneId
    private static let requiredDefaultParams = ["company_id": Config.ApiDefaultValues.companyId,
                                                "account_id": Utils.shared.phoneId,
                                                "device": Config.ApiDefaultValues.device]        as [String : Any]
    
    override init() {
        super.init()
        apiName = "Доставка"
    }
    
    //MARK: lowlevel funcs
    func save(entity: Delivery, completion: @escaping (_ result: Delivery?, _ error: APIError?) -> Void) {
        
        post(
            url: "\(url)",
            params: mergeParams(APIDelivery.requiredDefaultParams, entity.toDictionary()),
            success: { json in
                //let entity: Delivery = json.transformJson()
                completion(nil, nil)
        },
            failure: {completion(nil, $0)}
        )
    }
}
