//
//  EditAddressViewController.swift
//  DeliveryFood
//
//  Created by Admin on 02/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class AddressEditController: UIViewController {
    class Builder {
        private let vc: AddressEditController!
        
        init() {
            let storyboard = UIStoryboard(name: "Account", bundle: nil)
            vc = storyboard.instantiateViewController(withIdentifier: "addressForm") as! AddressEditController
        }
        
       
        func setValue(_ value: Address) -> Self {
            vc.item = value
            return self
        }

        func onSave(_ value: @escaping (Address)->Void) -> Self {
            vc.callbackOnSave = value
            return self
        }
        
        func show(parentController parent: UIViewController) {
            
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.view.backgroundColor = vc.view.tintColor
            vc.navigationItem.leftBarButtonItem?.tintColor = vc.view.tintColor
            vc.navigationItem.rightBarButtonItem?.tintColor = vc.view.tintColor
            
            parent.present(navigationVC, animated: true, completion: nil)

        }
    }
    
    fileprivate var item: Address?
    var callbackOnSave: ((Address)->Void)?
    var dataContext: AddressesContext!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        editStreetHouse.layer.borderColor = view.tintColor.cgColor
        
        fillForm(address: item)


    }

    @IBOutlet weak var editStreetHouse: UITextField!
    @IBOutlet weak var editFlat: TextFieldWithLabelBelow!
    @IBOutlet weak var editFloor: TextFieldWithLabelBelow!
    @IBOutlet weak var editEntrance: TextFieldWithLabelBelow!
    @IBOutlet weak var editCode: TextFieldWithLabelBelow!
    @IBOutlet weak var editName: UITextField!
    
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBAction func onSave(_ sender: Any) {
        save()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let destroyAction = UIAlertAction(title: "Удалить",
        style: .destructive) { (action) in
            self.delete()
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel)
        
        let alert = UIAlertController(title: "Вы хотите удалить этот адрес?",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
   
    @IBAction func onChooseStreetHouse(_ sender: Any) {
        SuggestAddressController.build(owner: self, initialValue: editStreetHouse.text, onDidChoose: { (street, house) in
            self.editStreetHouse.text = !street.isEmpty && !house.isEmpty ? "\(street), \(house)" : ""
        }).present()
    }
    
    
}

//MARK: Helplers
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
