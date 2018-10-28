//
//  AddressListViewController.swift
//  DeliveryFood
//
//  Created by Admin on 27/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Eureka

class AddressListController: FormViewController {
    class Builder {
        private let vc: AddressListController!
        
        init() {
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: "addressList") as! AddressListController
        }
        
        func setChooseMode(_ value: Bool) -> Self {
            vc.chooseMode = value
            return self
        }
        
        func setValue(_ value: Address?) -> Self {
            vc.item = value
            return self
        }
        
        func onDidSelect(_ value: @escaping (Address)->Void) -> Self {
            vc.callbackOnDidSelect = value
            return self
        }
        
        func onClose(_ value: @escaping ()->Void) -> Self {
            vc.callbackOnClose = value
            return self
        }
        
        func setDataContext(_ value: AddressesContext) -> Self {
            vc.kind = value.kind
            vc.dataContext = value
            return self
        }

        func show(parentController parent: UIViewController) {
            parent.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    var dataContext: AddressesContext!
    
    fileprivate var chooseMode: Bool = true
    fileprivate var item: Address?
    fileprivate var callbackOnDidSelect: ((Address)->Void)?
    fileprivate var callbackOnClose: (()->Void)?
    fileprivate var kind: AddressesKind = .user

    override func viewDidLoad() {
        super.viewDidLoad()

        if !dataContext.isMutable {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillForm()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        callbackOnClose?()
    }
    
    func createForm() {
        var addresses: [Address]!
        if dataContext != nil {
            addresses = dataContext!.model
        } else {
            //dummy
            addresses = [Address().fillByDummy(), Address().fillByDummy(), Address().fillByDummy()]
            addresses[1].name = nil
            addresses[2].street = "ул. Маховая"
        }
        
        form.removeAll()
        form
            +++ SelectableSection<AddressRow>()  {
                $0.onSelectSelectableRow = {(cell, row) in
                    if row.selectableValue != nil {
                        self.dataContext?.defaultItem = row.selectableValue
                        self.navigationController?.popViewController(animated: true)
                        self.callbackOnDidSelect?(row.selectableValue!)
                    }
                }
        }
        
        for option in addresses {
            form.last! <<< AddressRow(){ lrow in
                lrow.selectableValue = option;
                lrow.value = option.id == item?.id ? option : nil
                if !self.dataContext.isMutable {lrow.cell.accessoryView = nil}
                }.onDetailButtonTapped({ row in
                    AddressEditController.Builder().setValue(option).show(parentController: self)
                })
        }
        
//        form +++ AddressRow () {
//            $0.value = Address()
//        }

        tableView.tableFooterView = UIView()
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        AddressEditController.Builder().show(parentController: self)
    }
}
