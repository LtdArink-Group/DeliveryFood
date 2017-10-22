//
//  ProfileViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 29.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Eureka
import UIKit
import Alamofire
import Crashlytics
import Fabric

class ProfileViewController: FormViewController {
    
    @IBOutlet weak var btn_bar: UIBarButtonItem!
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var addresses: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        get_user_info()
    }
    
    func get_user_info()
    {
        ID_phone = "eb5378e4-48e6-4d03-b954-d00739b8c8ff"
        let url = SERVER_NAME + "/api/accounts/" + ID_phone
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                if let json = response.result.value  as? [String: Any] {
                    if json["status"] as? Int == nil
//                    if  200 ... 300 ~= json["status"] as! Int
                    {
                        self.name = json["name"] as! String
                        self.email = json["email"] as! String
                        self.phone = json["phone"] as! String
                        self.addresses = json["addresses"] as! [[String: Any]]
                        self.create_form()
                    }
                    else
                    {
                        self.create_form()
                    }
                }
        }
    }
    
    func create_form()
    {
        
        form
        
            +++ Section("Клиент")
            <<< TextRow("NameRow"){ row in
                row.title = "Имя"
                row.placeholder = "Введите ваше имя"
                row.add(rule: RuleMinLength(minLength: 3))
                row.add(rule: RuleMaxLength(maxLength: 50))
                row.value = name
//                row.disabled = true
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.contentView.backgroundColor = .red
                                    cell.textLabel?.textColor = .white
                                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                                    cell.textLabel?.textAlignment = .right
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
            
            +++ Section("Контакты")
            <<< PhoneRow("PhoneRow"){
                $0.title = "Телефон"
//                $0.disabled = true
                $0.placeholder = "7XXXXXXXXXX"
                $0.add(rule: RuleMinLength(minLength: 6))
                $0.add(rule: RuleMaxLength(maxLength: 11))
                $0.add(rule: RuleRequired())
                $0.value = phone
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.contentView.backgroundColor = .red
                                    cell.textLabel?.textColor = .white
                                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                                    cell.textLabel?.textAlignment = .right
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
                
            <<< EmailRow("EmailRow"){
                $0.title = "Email"
//                $0.disabled = true
                $0.placeholder = "email@me.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.value = email
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                }.cellUpdate { cell, row in
                                    cell.contentView.backgroundColor = .red
                                    cell.textLabel?.textColor = .white
                                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                                    cell.textLabel?.textAlignment = .right
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
        edit_address_form()
    }
    
    @IBAction func on_clicked_btn_bar(_ sender: UIBarButtonItem)
    {
        save()
        
//        if sender.title == "Изменить"
//        {
//            sender.title = "Сохранить"
//            enabled_fields()
////            hide_address()
////            edit_address_form()
//        }
//        else
//        {
//            sender.title = "Изменить"
////            disabled_fields()
////            hide_address()
//        }
    }
    
    func disabled_fields()
    {
        let name_row: TextRow = self.form.rowBy(tag: "NameRow")!
        let phone_row: PhoneRow = self.form.rowBy(tag: "PhoneRow")!
        let email_row: EmailRow = self.form.rowBy(tag: "EmailRow")!
        name_row.disabled = true
        phone_row.disabled = true
        email_row.disabled = true
//        print(name_row.title)
    }
    
    func enabled_fields()
    {
        let name_row: TextRow = self.form.rowBy(tag: "NameRow")!
        let phone_row: PhoneRow = self.form.rowBy(tag: "PhoneRow")!
        let email_row: EmailRow = self.form.rowBy(tag: "EmailRow")!
        name_row.disabled = false
        name_row.updateCell()
        phone_row.disabled = false
        email_row.disabled = false
        
    }
    
    func hide_address()
    {
        let address_section: Section = self.form.sectionBy(tag: "SectionAddress")!
        address_section.hidden = true
        self.form.rowBy(tag: "AddressHome")!.hidden = true
        self.form.rowBy(tag: "AddressWork")!.hidden = true
//        print("djhjkhdjhdgfjhgdfhjk")
//        print(address_section.isHidden)
//        if address_section.isHidden
//        {
////            address_section.hidden = false
//        }
//        else
//        {
////            address_section.hidden = true
//        }
    }
    
    func go_to_address(each: [String: Any])
    {
//        performSegue(withIdentifier: "go_to_address", sender: nil)
        let controller : AddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        controller.arr_address = each
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func edit_address_form()
    {
        form
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Адреса",
                                   footer: "Вы можете добавить несколько адресов доставки"
            ) {
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Добавить адрес"
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return LabelRow {
                        $0.title = "Новый адрес"
                        $0.cell.accessoryType = .disclosureIndicator
                        $0.baseCell.accessoryType = .disclosureIndicator
                        }.onCellSelection {_,_ in
                            self.go_to_address(each: [:])
                        }.cellUpdate { cell, row in
                            Helper().delay(1)
                            {
                                self.go_to_address(each: [:])
                            }
                    }
                }
                for each in addresses
                {
                    $0 <<< LabelRow() {
                        $0.title = each["title"] as? String
                        $0.cell.accessoryType = .disclosureIndicator
                        }.onCellSelection {_,_ in
                            self.go_to_address(each: each)
                        }.cellUpdate { cell, row in
                            row.cell.accessoryType = .disclosureIndicator
                    }
                }
        }
    }
    
    func save()
    {
        let tbc = storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as? UITabBarController
        tbc?.selectedIndex = 0
        tabBarController?.present(tbc!, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

