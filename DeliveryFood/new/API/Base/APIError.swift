//
//  APIError.swift
//  mvvm-sample
//
//  Created by Fernando Martinez on 5/3/16.
//  Copyright © 2016 fernandodev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct APIError {
    static let NOT_FOUND = 404
    
    var code: Int = Int.max
    var requestBody: AnyObject?
    var apiName: String?
    var errors: [String: String] = Dictionary()
    var description: String {
        switch code {
        case 400:
            return "Плохой запрос"
        case 401:
            return "Ошибка доступа"
        case APIError.NOT_FOUND:
            return "Не найдено"
        case 422:
            return errors.count > 0 ? "\(errors.first!.key) \(errors.first!.value)" : "Неизвестная ошибка"
        default:
            return "Неизвестная ошибка"
        }
    }

    init(apiName: String? = nil) {
        self.apiName = apiName
    }

    init(code: Int, apiName: String?) {
        self.init(apiName: apiName)
        self.code = code

    }

    init(code: Int, requestBody: AnyObject?, apiName:String? = nil) {
        let json = JSON(requestBody as Any)

        self.init(code: code, json:json, apiName:apiName)
        self.requestBody = requestBody
    }
    
    init(code: Int, json: JSON?, apiName:String? = nil) {
        self.init(code: code, apiName: apiName)
        self.apiName = apiName
        if let errs = json?["errors"] {
            
            for (key,value) in errs {
                self.errors[key] = value.arrayValue.first?.stringValue

                //not good looks if many errors on single key
                //            self.errors[key] = value.arrayValue.reduce("", { (value:String, item) -> String in
                //                return value + " \(item.stringValue)!"
                //            })
            }
        }
        
    }
}
