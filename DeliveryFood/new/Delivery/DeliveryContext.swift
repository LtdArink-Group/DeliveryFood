//
//  DeliveryViewModel.swift
//  DeliveryFood
//
//  Created by Admin on 24/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Foundation

class DeliveryContext {
    var model: Delivery
    
    var deliveryCost: Double!
    var pickupDiscount :Int!
    var availableTimePeriodForOrder: (sh: Int, sm: Int, eh: Int, em: Int)!
    var callbackDeliveryDidSent: (()->Void)?
    
    fileprivate var userAddresses: AddressesContext = AddressesContext()
    fileprivate var companyAddresses: AddressesContext = AddressesContext(kind: .company)
    
    var currentDate = Date()
    
    init(model: Delivery) {
        self.model = model
        

    }
    
    func save(_ completion: @escaping (_ error: String?) -> Void) {
        //todo maybe save shallow copy and assign to model after success
        try! AccountContext(model: model.account).saveIfNeeded { error in
            if error == nil {
                APIDelivery().save(entity: self.model, completion: { (delivery, error) in
                    completion(error?.description)
                })
            } else {
                completion(error)
            }
        }
    }
}

extension DeliveryController {
    private var model: Delivery {return self.dc.model}
    
    func fillFields (_ completion: @escaping (_ error: String?) -> Void) {
        let model = self.dc.model
        loadDataIfNeeded { error in
            if error == nil {
                
                self.form.rowBy(tag: "phone")?.value = model.account.phone
                self.form.rowBy(tag: "name")?.value = model.account.name
                self.form.rowBy(tag: "pickup")?.value = model.pickup
                
                self.form.rowBy(tag: "userAddress")?.value = self.dc.userAddresses.defaultItem
                self.form.rowBy(tag: "companyAddress")?.value = self.dc.companyAddresses.defaultItem
                
                //additional
                if self.dc.companyAddresses.model.count < 2 {
                    self.form.rowBy(tag: "companyAddress")?.baseCell.accessoryType = .none
                    self.form.rowBy(tag: "companyAddress")?.baseCell.isSelected = false;
                }
                
                //for applying tint color
                self.form.rowBy(tag: "send")?.updateCell()
            }
            completion(error)
        }
    }
    
    private func loadDataIfNeeded(_ completion:@escaping (_ error: String?) -> Void) {
        //todo via queue - parallely
        AccountContext().get({account, error in
            if error == nil {
                self.model.account = account
                
                self.dc.userAddresses.get({ (addresses, error) in
                    if error == nil {
                        self.dc.companyAddresses.get({ (addresses, error) in
                            if let addrs = addresses {
                                if addrs.count > 0 {
                                    self.model.address = addrs[0]
                                }
                            }
                            completion(error)
                        })
                    } else {
                        completion(error)
                    }
                })

            } else {
                completion(error)
            }
        })
    }
    
    
    
    func send() {
        let model = self.dc.model
        
        model.account.phone = self.form.rowBy(tag: "phone")?.value
        model.account.name = self.form.rowBy(tag: "name")?.value
        model.pickup = self.form.rowBy(tag: "pickup")?.value ?? false
        model.address = model.pickup ? self.form.rowBy(tag: "companyAddress")?.value : self.form.rowBy(tag: "userAddress")?.value
        model.time = earlyTime ? nil : self.form.rowBy(tag: "time")?.value
        model.note = self.form.rowBy(tag: "note")?.value

        self.dc.save { error in
            if error == nil {
                //todo show congratulation
                debugPrint("order is sent")
                self.dc.callbackDeliveryDidSent?()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller : WellDoneViewController = storyboard.instantiateViewController(withIdentifier: "WellDoneViewController") as! WellDoneViewController
                self.navigationController?.present(controller, animated: true)
                //self.navigationController?.dismiss(animated: false)
            }
            //todo show error
        };
    }
    
    func chooseUserAddress() {
        if let value:Address = self.form.rowBy(tag: "userAddress")?.value { //not empty
        AddressListController.Builder()
            .setDataContext(self.dc.userAddresses)
            .setValue(value)
            .onDidSelect({ address in
                self.form.rowBy(tag: "userAddress")?.value = address
                self.form.rowBy(tag: "userAddress")?.reload()                
            }).onClose {
                self.form.rowBy(tag: "userAddress")?.value = self.dc.userAddresses.defaultItem
                self.form.rowBy(tag: "userAddress")?.reload()
            }
            .show(parentController: self)
        } else {
            AddressEditController.Builder()
                .onSave({ address in
                    self.form.rowBy(tag: "userAddress")?.value = address
                    self.form.rowBy(tag: "userAddress")?.reload()
                    AccountContext().reload() //refresh Account todo via message or something like
                })
                .show(parentController: self)
        }
    }
    func chooseCompanyAddress() {
        guard self.dc.companyAddresses.model.count > 1 else { return}
        
        AddressListController.Builder()
            .setDataContext(self.dc.companyAddresses)
            .setValue(self.form.rowBy(tag: "companyAddress")?.value)
            .onDidSelect({ address in
                self.form.rowBy(tag: "companyAddress")?.value = address
            })
            .show(parentController: self)
    }
    
    func createTotalString() -> String? {
        let pickup = form.rowBy(tag: "pickup")?.value ?? false
        
        let delPart = dc.deliveryCost > 0 ?  (pickup ? " без стоимости доставки" : " с доставкой") : ""
        let discPart = CostCalculator.isExistDiscount(forPickup: pickup) ? String(format: " %@ со скидкой", !delPart.isEmpty ? "и" : "") : ""
        
        guard !delPart.isEmpty || !discPart.isEmpty else {return nil}
        
        return String(format: "Итого%@%@ %d руб.", delPart, discPart, CostCalculator.getTotalCostWith(orderCost: Int(dc.model.order.summaNetto), pickup: pickup))
    }
    
    //helper
//    func getRow<T>(_ key: String) -> RowOf<T>? where T: Equatable {
//        return self.form.rowBy(tag: key)
//    }
    
}

