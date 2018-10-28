//
//  JSONDeserialization.swift
//  mvvm-sample
//
//  Created by Fernando Martinez on 5/5/16.
//  Copyright © 2016 fernandodev. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONApiAble {
    init(json: JSON)
    func toDictionary() -> [String: Any] 
}
