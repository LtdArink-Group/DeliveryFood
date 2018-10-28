//
//  Config.swift
//  DeliveryFood
//
//  Created by Admin on 16/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Foundation

struct Config {
    private init() {}
    struct ApiDefaultValues {
        static let companyId = 1
        static let city = "Хабаровск"
        static let tzOffset = "+10"
        static let device = "iphone"
        //static var defaultPhoneId:String? = nil
    }
    
    struct AlertClosures {
        static let loading: (Bool)->Void = {visible in if visible {PageLoading().showLoading()} else {PageLoading().hideLoading()}}
        static let showError: (String?)->Void = {text in ShowError2().show_error(text: text ?? "Что то пошло не так")}
    }
    
    struct Texts {
        static let localTimeShortName = "хабаровское"
        static let generalError = "Произошла сетевая ошибка! Повторите попытку позже."
    }
    
    struct Delivery {
        static let deliveryOffsetFromCurrentTime = 60.0 //min
    }

}
