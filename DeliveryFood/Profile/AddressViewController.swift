//
//  AddressViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 29.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Eureka
import UIKit
import Alamofire
class AddressViewController: FormViewController, UINavigationControllerDelegate {
        
    @IBOutlet weak var btn_bar_delete: UIBarButtonItem!
    
    var arr_address: [String: Any] = [:]
    var name = ""
    var email = ""
    var phone = ""
    var new_address = false
    var new_profile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        btn_bar_delete.isEnabled = !new_address
        create_form()
    }

    func create_form()
    {
        form

            +++ Section("Адрес")
            <<< TextRow("NameAddressRow"){ row in
                row.title = "Название адреса"
                row.placeholder = "Домашний"
                row.add(rule: RuleRequired())
                row.value = arr_address.count > 0 ? arr_address["title"] as! String: ""
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
            <<< TextRow("AddressRow"){ row in
                row.title = "Улица"
                row.placeholder = "Ленинградская"
                row.value = arr_address.count > 0 ? arr_address["street"] as! String : ""
                row.add(rule: RuleRequired())
                row.hidden = true
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
            <<< TextRow("HouseRow"){ row in
                row.title = "Дом"
                row.placeholder = "26"
                row.hidden = true
                row.cell.textField.keyboardType = .numbersAndPunctuation
                row.add(rule: RuleRequired())
                row.value = arr_address.count > 0 ? arr_address["house"] as! String : ""
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
            <<< TextRow("streethouse") {
                $0.title = "Дом"
                $0.placeholder = "Выберете улицу и дом"
                $0.add(rule: RuleRequired())

                }.cellSetup({ (cell, row) in
                    if (self.form.rowBy(tag: "AddressRow") as! TextRow).value != nil
                        && (self.form.rowBy(tag: "HouseRow") as! TextRow).value != nil
                        && !(self.form.rowBy(tag: "AddressRow") as! TextRow).value!.isEmpty
                        && !(self.form.rowBy(tag: "HouseRow") as! TextRow).value!.isEmpty {
                        row.value = "\((self.form.rowBy(tag: "AddressRow") as! TextRow).value!), \((self.form.rowBy(tag: "HouseRow") as! TextRow).value!)"
                    }
                })
                .onCellSelection({ (cell, row) in
                    SuggestAddressController.build(owner: self, initialValue: row.value, onDidChoose: { (street, house) in
                        row.value = !street.isEmpty && !house.isEmpty ? "\(street), \(house)" : ""
                        (self.form.rowBy(tag: "AddressRow") as! TextRow).value = street
                        (self.form.rowBy(tag: "HouseRow") as! TextRow).value = house
                    }).present()
                }).cellUpdate({ (cell, row) in
                    cell.textField.isUserInteractionEnabled = false
                })
            <<< TextRow("FlatRow"){ row in
                row.title = "Квартира/офис"
                row.placeholder = "605"
                row.cell.textField.keyboardType = .numbersAndPunctuation
                row.value = arr_address.count > 0 ? arr_address["office"] as! String : ""
                }.onChange { row in
//                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("GrandRow"){ row in
                row.title = "Подъезд"
                row.placeholder = "1"
                row.cell.textField.keyboardType = .numbersAndPunctuation
                row.value = arr_address.count > 0 ? arr_address["entrance"] as! String : ""
                }.onChange { row in
//                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("LevelRow"){ row in
                row.title = "Этаж"
                row.placeholder = "6"
                row.cell.textField.keyboardType = .numbersAndPunctuation
                row.value = arr_address.count > 0 ? arr_address["floor"] as! String : ""
                }.onChange { row in
//                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("CodeRow"){ row in
                row.title = "Код двери"
                row.placeholder = "605"
                row.cell.textField.keyboardType = .numbersAndPunctuation
                row.value = arr_address.count > 0 ? arr_address["code"] as! String : ""
                }.onChange { row in
//                    self.btn_bar.title = "Сохранить"
        }
         +++ Section("")
            <<< ButtonRow("SaveRow"){ row in
                row.title = "Сохранить"
                row.cell.selectionStyle = .none
                row.cell.tintColor = UIColor.white
                row.cell.backgroundColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
                }.onCellSelection {_,_ in
                    self.on_clicked_btn_save()
        }
    }
    
    func create_json_data() -> [String: String]
    {
        let title_row: TextRow = self.form.rowBy(tag: "NameAddressRow")!
        let address_row: TextRow = self.form.rowBy(tag: "AddressRow")!
        let house_row: TextRow = self.form.rowBy(tag: "HouseRow")!
        let flat_row: TextRow = self.form.rowBy(tag: "FlatRow")!
        let grand_row: TextRow = self.form.rowBy(tag: "GrandRow")!
        let level_row: TextRow = self.form.rowBy(tag: "LevelRow")!
        let code_row: TextRow = self.form.rowBy(tag: "CodeRow")!
        let title_ = title_row.value == nil ? "" : title_row.value as! String
        Last_title_address = title_
        
        let address = address_row.value == nil ? "" : address_row.value as! String
        
        let house = house_row.value == nil ? "" : house_row.value as! String
        
        let flat = flat_row.value == nil ? "" : flat_row.value as! String
        
        let level = level_row.value == nil ? "" : level_row.value as! String
        
        let grand = grand_row.value == nil ? "" : grand_row.value as! String

        let code = code_row.value == nil ? "" : code_row.value as! String
        
        return [
                "title": title_,
                "street": address,
                "house": house,
                "office": flat,
                "floor": level,
                "entrance": grand,
                "code": code,
                "city": CITY
        ]
    }
    
    @IBAction func on_clicked_btn_delete(_ sender: UIBarButtonItem) {
        let id = arr_address["id"] as! Int
        let url = SERVER_NAME + "/api/accounts/\(ID_phone)/addresses/\(id)"
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                print(response)
                if response.result.value != nil {
                    self.go_back(delete: true)
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_INTERNET)
                }
        }
    }
    
    func on_clicked_btn_save() {
        PageLoading().showLoading()
        if new_profile && name != ""
        {
            post_profile()
        }
        else if new_profile && name == ""
        {
            ShowError().show_error(text: ERR_NEED_ADD_CONTACT)
        }
        else if !new_profile && new_address
        {
            post_address()
        }
        else {
            update()
        }
    }
    
    func post_profile()
    {
        let url = SERVER_NAME + "/api/accounts/"
        let params = [
            "id": "\(ID_phone)",
            "name": name,
            "phone": phone,
            "email": email
            ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    self.post_address()
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_INTERNET)
                }
        }
    }
    
    func post_address()
    {
        let url = SERVER_NAME + "/api/accounts/\(ID_phone)/addresses"
        let params = create_json_data()
        print(url)
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    if let json = response.result.value as? [String: Any] {
                        if json["errors"] as? [String: Any] == nil
                        {
                            self.go_back(delete: false)
                        }
                        else {
                            ShowError().show_error(text: ERR_CHECK_DATA)
                        }
                    }
                    else {
                        self.go_back(delete: false)
                    }
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_INTERNET)
                }
        }
    }
    
    func update()
    {
        let id = arr_address["id"] as! Int
        let url = SERVER_NAME + "/api/accounts/\(ID_phone)/addresses/\(id)"
        let params = create_json_data()
        
        Alamofire.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    if let json = response.result.value as? [String: Any] {
                        if json["errors"] as? [String: Any] == nil
                        {
                            self.go_back(delete: false)
                        }
                        else {
                            ShowError().show_error(text: ERR_CHECK_DATA)
                        }
                    }
                    else {
                        self.go_back(delete: false)
                    }
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_INTERNET)
                }
        }
    }
    
    
    func go_back(delete: Bool)
    {
        PageLoading().hideLoading()
        self.navigationController?.popViewController(animated: true)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload_address"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

