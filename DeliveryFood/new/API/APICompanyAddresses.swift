//
//  APICompanyAddresses.swift
//  DeliveryFood
//
//  Created by Admin on 02/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class APICompanyAddresses: APIAddresses {
    override var url: String {return APIBase.baseUrl + "/api/companies/\(Config.ApiDefaultValues.companyId)"}
    
    override init() {
        super.init()
        apiName = "Компания (адреса)"
    }
    
    
    
    
}
