//
//  JSON.swift
//  mvvm-sample
//
//  Created by Fernando Martinez on 5/5/16.
//  Copyright © 2016 fernandodev. All rights reserved.
//

import SwiftyJSON

extension JSON {

    func transformJson<T: JSONApiAble>() -> T {
        return T(json: self)
    }

    func transformJsonArray<T: JSONApiAble>() -> [T] {
        var array: [T] = []

        assert(self.type == .array)

        for index in 0...(self.count-1) {
            let e = self[index]
            array.append(T(json: e))
        }

        return array
    }
}
