import Foundation
import SwiftyJSON

class APIAddresses: APIBase {
    var url:String {return APIBase.baseUrl + "/api/accounts/\(self.accountId)"}
    var accountId: String = Utils.shared.phoneId
    private static let requiredDefaultParams = ["city": Config.ApiDefaultValues.city]

    override init() {
        super.init()
        apiName = "Адрес"
    
    }
    
    func load(completion: @escaping (_ result: [Address]?, _ error: APIError?) -> Void) {
        
        get(
            url: url,
            params: nil,
            success: { json in
                var entities:[Address] = []
                if let items = json["addresses"].array {
                    for item: JSON in items {
                        let entity: Address = item.transformJson()
                        entities.append(entity)
                    }
                }
                completion(entities, nil)
        },
            failure: {completion(nil, $0)}
        )
    }
    
    func save(entity: Address, completion: @escaping (_ result: Address?, _ error: APIError?) -> Void) {
        
        if entity.isNew {
            _add(entity: entity, completion:{address, error in
                //because api is was some way - without existing account no saving address
                if error?.code == APIError.NOT_FOUND {
                    APIAccount().saveFictionAccount(completion: { (account, error) in
                        if error == nil {
                            //return again
                            self._add(entity: entity, completion: completion)
                        } else {
                            completion(address, error)
                        }
                    })
                } else {
                    completion(address, error)
                }
            })
        } else {
            _update(entity: entity, completion: completion)
        }
    }
    
    func delete(entity: Address, completion: @escaping (_ error: APIError?) -> Void) {
        
        delete(
            url: "\(url)/addresses/\(entity.id!)",
            success: {completion(nil)},
            failure: {completion($0)}
        )
    }
    
    //MARK: lowlevel funcs
    private func _add(entity: Address, completion: @escaping (_ result: Address?, _ error: APIError?) -> Void) {
        
        post(
            url: "\(url)/addresses",
            params: mergeParams(APIAddresses.requiredDefaultParams, entity.toDictionary()),
            success: { json in
                let entity: Address = json.transformJson()
                //PerssistData.shared.account = account
                completion(entity, nil)
        },
            failure: {completion(nil, $0)}
        )
    }
    
    private func _update(entity: Address, completion: @escaping (_ result: Address?, _ error: APIError?) -> Void) {
        
        patch(
            url: "\(url)/addresses/\(entity.id!)",
            params: mergeParams(APIAddresses.requiredDefaultParams, entity.toDictionary()),
            success: { json in
                //PerssistData.shared.account = account
                completion(entity, nil)
        },
            failure: {completion(nil, $0)}
        )
    }

    
}





