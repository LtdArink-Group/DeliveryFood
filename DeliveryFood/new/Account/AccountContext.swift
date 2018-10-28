//
//  AccountContext.swift
//
//  Created by Admin on 16/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class AccountContext {
    private(set) var model: Account!
    
    enum AppError: Error {
        case noNewModelInInit
    }
    
    //private let loadingClosure:(Bool)->() = Config.AlertClosures.loading

    init () {}
    
    init (model: Account) throws {
//        if model.isNew {
//            throw AppError.noNewModelInInit
//        }
        self.model = model
    }
    
    func reload() {
        PerssistData.shared.data["\(type(of: self.model))"] = nil
        get { (_, _) in
            
        }
    }
    
    func get (_ completion: @escaping (_ account: Account?, _ error: String?) -> Void) {
        if let data = PerssistData.shared.data["\(type(of: model))"] as? Account {
            self.model = data
            completion(self.model, nil)
        } else {
            APIAccount().load(completion: { (account, error) in
                if error == nil {
                    self.model = account
                }
                PerssistData.shared.data["\(type(of: self.model))"] = account
                completion(self.model , error?.description)
            })
        }
    }
    
    func saveIfNeeded(_ completion: @escaping (_ error: String?) -> Void) {
        if let acc = PerssistData.shared.data["\(type(of: model))"] as? Account{
            if model.isNew { //someone saved it already, TODO more suitable way
                acc.phone = model.phone
                acc.email = model.email
                acc.name = model.name
                model = acc
            }
        }
        
        if model.isModificated  {
 
            APIAccount().save(account: model) { (account, error) in

                if (error == nil) {
                    self.model = account
                    print("ok")
                }
                PerssistData.shared.data["\(type(of: self.model))"] = account
                completion(error?.description)
            }
        } else {
            completion(nil)
        }
    }
}
