//
//  Address.swift
//  DeliveryFood
//
//  Created by Admin on 24/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import SwiftyJSON

public class Address: Model {

    var id: Int?
    var street: String = ""
    var house: String = ""
    var flat: String?
    var floor: String?
    var entrance: String?
    var code: String?
    
    var name: String?
    override var isNew: Bool {return self.id == nil }
    
    override init() {
        super.init()
        
    }
    
    required public init(json: JSON) {
        super.init(json: json)
        
        id = json["id"].int
        street = json["street"].stringValue
        house = json["house"].stringValue
        flat = emptyToNil(json["office"].string)
        floor = emptyToNil(json["floor"].string)
        entrance = emptyToNil(json["entrance"].string)
        code = emptyToNil(json["code"].string)
        name = emptyToNil(json["title"].string)
        
    }
    
    override func toDictionary() -> [String: Any] {
        var params = Dictionary<String, Any>()
        params["street"] = street
        params["house"] = house
        if (flat != nil) {params["office"] = flat}
        if (floor != nil) {params["floor"] = floor}
        if (entrance != nil) {params["entrance"] = entrance}
        if (code != nil) {params["code"] = code}
        if (name != nil) {params["title"] = name}
        return params
    }
    
    override func equals(rhs _rhs: Model) -> Bool {
        let lhs = self
        let rhs = _rhs as! Address
        return
            lhs.street == rhs.street &&
                lhs.house == rhs.house &&
                lhs.flat == rhs.flat &&
                lhs.floor == rhs.floor &&
                lhs.entrance == rhs.entrance &&
                lhs.code == rhs.code &&
                lhs.name == rhs.name;
    }
    
    func getAddressString() -> String {
        var res = "\(street)"
        if !house.isEmpty {res = "\(res), \(house)"}
        if flat != nil {res = "\(res), \(flat!)"}
        
        return res
    }
    
    func getFullAddressString() -> String {
        var res = getAddressString()
            
        var adds:[String] = []
        if floor != nil {adds.append("эт: \(floor!)")}
        if entrance != nil {adds.append("под: \(entrance!)")}
        if code != nil {adds.append("код: \(code!)")}
        
        if adds.count > 0 {
            res += "(" + adds.joined() + ")"
        }
        
        return res
    }
    
    var streetHouse: String {
        get {
            if !street.isEmpty && !house.isEmpty {
                return "\(street), \(house)"
            }
            return ""
        }
        set {
            let addressParts = type(of: self).getStreetAndHouseNumber(addressTitle: newValue)
            
            street = addressParts.0
            house = addressParts.1
        }
    }
    
    //MARK: local helper
    public static func getStreetAndHouseNumber(addressTitle: String?) -> (String, String) {
        var result = ("","")
        if addressTitle == nil {
            return result
        }
        let a = addressTitle!
        var i = a.range(of: ",", options: .backwards)?.lowerBound
        if i == nil {
            i = a.range(of: " ", options: .backwards)?.lowerBound
        }
        if (i != nil && i! < a.endIndex) {
            result.0 = String(a[..<i!])
            let i2 = a.index(a.startIndex, offsetBy: i!.encodedOffset+1)
            result.1 = String(a[i2...]).trimmingCharacters(in: .whitespacesAndNewlines)
            debugPrint("steet: ", result.0)
            debugPrint("house: ", result.1)
        }
        
        return result
    }
}



//MARK: dummy
extension Address {
    func fillByDummy() -> Self {
        street = "ул. Буденова"
        house = "32б"
        name = "Дом"
        
        return self
    }
}
