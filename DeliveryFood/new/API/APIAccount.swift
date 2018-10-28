import Foundation
import SwiftyJSON

class APIAccount: APIBase {
    var url = APIBase.baseUrl + "/api/accounts"
    var id: String = Utils.shared.phoneId
    
    private let FICTION_PHONE = "+74000000000"
    
    override init() {
        super.init()
        apiName = "Профиль"
    }
    
    func load(completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {

        _get { (account, error) in
            if error == nil {
                if account?.phone == self.FICTION_PHONE {account?.phone = nil}
                completion(account, nil)
            } else {
                if error?.code == APIError.NOT_FOUND {
                    completion(Account(), nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func save(account: Account, completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {
        
        if account.isNew {
            _add(account: account, completion: completion)
        } else {
            _update(account: account, completion: completion)
        }
    }
    
    //needs for addint address, becaue back api is that
    func saveFictionAccount(completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {
        let fictionAccount = Account()
        fictionAccount.phone = FICTION_PHONE;
        
        save(account: fictionAccount, completion: completion);
    }
    
    //MARK: lowlevel funcs
    private func _get(completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {

        get(
            url: "\(url)/\(id)",
            params: nil,
            success: { json in
                let account: Account = json.transformJson()
                completion(account, nil)
            },
            failure: {completion(nil, $0)}
        )
    }

    private func _add(account: Account, completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {

        post(
            url: url,
            params: mergeParams(["id":id], account.toDictionary()),
            success: { json in
                let account: Account = json.transformJson()
                completion(account, nil)
        },
            failure: {completion(nil, $0)}
        )
    }

    private func _update(account: Account, completion: @escaping (_ result: Account?, _ error: APIError?) -> Void) {
        
        post(
            url: "\(url)/\(id)/update",
            params: account.toDictionary(),
            success: { json in
                let account: Account = json.transformJson()
                completion(account, nil)
        },
            failure: {completion(nil, $0)}
        )
    }
    
    internal func _delete(completion: @escaping (_ error: APIError?) -> Void) {
        
        delete(
            url: "\(url)/\(id)",
            success: {completion(nil)},
            failure: {completion($0)}
        )
    }

}






