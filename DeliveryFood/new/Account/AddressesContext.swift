//
//  AddressesContext.swift
//  DeliveryFood
//
//  Created by Admin on 19/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

enum AddressesKind {
    case user, company
}

class AddressesContext {
    private(set) var model: [Address] = []

    private(set) var modelItem: Address!

    var kind = AddressesKind.user
    
    var defaultItem: Address? {
        get {
            let id = UserDefaults.standard.integer(forKey: "addressId_\(kind.hashValue)")
            let item =  getAddressById(id)
            return item ?? (model.count > 0 ? model[0] : nil)
        }
        set {
            UserDefaults.standard.set(newValue?.id, forKey: "addressId_\(kind.hashValue)")
        }
    }

    var isMutable:Bool {return kind == .user}
    
    
    init() {}
    
    init(kind: AddressesKind) {
        self.kind = kind
    }

    init(address: Address?) {
        self.modelItem = address ?? Address()
    }

    func getAddressById(_ id:Int) -> Address? {
        for a in model {
            if a.id == id {
                return a
            }
        }
        return nil
    }
    
    func get(_ completion: @escaping (_ addresses: [Address]?, _ error: String?) -> Void) {
        let storeKey = "\(type(of: self))_\(kind)"
        let api = kind == .user ? APIAddresses() : APICompanyAddresses()
        
        if let data = PerssistData.shared.data[storeKey] as? [Address] {
            self.model = data
            completion(data, nil)
        } else {
            api.load {(addresses, error) in
                self.model = addresses ?? []
                PerssistData.shared.data[storeKey] = self.model as AnyObject
                completion(self.model, error?.code == APIError.NOT_FOUND ? nil : error?.description)
            }
        }
    }

    func saveAddress(_ completion: @escaping (_ entity: Address?, _ error: String?) -> Void) {
        saveAddress(modelItem) { (entity, error) in
            if (error == nil) {
                self.modelItem = entity
            }
            completion(entity, error)
        }
    }

    private func saveAddress(_ address: Address, _ completion: @escaping (_ entity: Address?, _ error: String?) -> Void) {
        let storeKey = "\(type(of: self))_\(kind)"
        APIAddresses().save(entity: address) { (address, error) in
            PerssistData.shared.data[storeKey] = nil
            
            if (error == nil) {
                self.get({ (addresses, error) in
                    completion(address, nil)
                })
            } else {
                completion(nil, error?.description)
            }
        }
    }
    
    func deleteAddress(_ completion: @escaping (_ error: String?) -> Void) {
        deleteAddress(modelItem, completion)
    }
    
    private func deleteAddress(_ address: Address, _ completion: @escaping (_ error: String?) -> Void) {
        let storeKey = "\(type(of: self))_\(kind)"
        APIAddresses().delete(entity: address) { error in
            PerssistData.shared.data[storeKey] = nil
            if (error == nil) {
                self.get({ (addresses, error) in
                    completion(nil)
                })
            } else {
                completion(error?.description)
            }
        }
    }
}

extension AddressListController {
    func fillForm () {
        if dataContext == nil {
            dataContext = AddressesContext()
        }
        
        dataContext?.get({ (adresses, error) in
            if error == nil {
                //self.tableView.reloadData()
                self.createForm()
            } else {
                Config.AlertClosures.showError(Config.Texts.generalError)
                self.navigationController?.popViewController(animated: true)
            }
            
        })
    }
}

extension AddressEditController {
    func fillForm (address: Address?) {
        if dataContext == nil {
            dataContext = AddressesContext(address: address)
        }
        
        editStreetHouse.text = dataContext.modelItem.streetHouse
        editFlat.text = dataContext.modelItem.flat
        editFloor.text = dataContext.modelItem.floor
        editEntrance.text = dataContext.modelItem.entrance
        editCode.text = dataContext.modelItem.code
        editName.text = dataContext.modelItem.name

        buttonDelete.isHidden = dataContext.modelItem.isNew
    }
    
    func save() {
        dataContext.modelItem.streetHouse = editStreetHouse?.text ?? ""
        dataContext.modelItem.flat = editFlat?.text ?? ""
        dataContext.modelItem.floor = editFloor?.text ?? ""
        dataContext.modelItem.entrance = editEntrance?.text ?? ""
        dataContext.modelItem.code = editCode?.text ?? ""
        dataContext.modelItem.name = editName?.text ?? ""

        dataContext.saveAddress {address, error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                if address != nil {
                    self.callbackOnSave?(address!)
                }
            }
        }
    }
    
    func delete() {
        dataContext.deleteAddress { error in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
