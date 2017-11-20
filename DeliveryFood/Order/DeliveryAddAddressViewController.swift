//
//  DeliveryAddAddressViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Eureka
import UIKit
import Alamofire
import Crashlytics
import Fabric

class DeliveryAddAddressViewController: FormViewController, UINavigationControllerDelegate {
    
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var delivery_time: String = ""
    var new_profile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddAddressViewController.goto_well_done), name: NSNotification.Name(rawValue: "show_well_done"), object: nil)
        
        create_form()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddAddressViewController.go_to_back), name: NSNotification.Name(rawValue: "well_done1"), object: nil)
    }
    
    @objc func go_to_back()
    {
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "well_done2"), object: nil)
    }
    
    
    func create_form()
    {
        form
            +++ Section("Адрес доставки заказа")
            <<< TextRow("NameAddressRow"){ row in
                row.title = "Название адреса"
                row.placeholder = "Домашний"
                row.add(rule: RuleRequired())
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
                row.add(rule: RuleRequired())
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
                row.add(rule: RuleRequired())
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
            <<< TextRow("FlatRow"){ row in
                row.title = "Квартира/офис"
                row.placeholder = "605"
            }
            <<< TextRow("GrandRow"){ row in
                row.title = "Подъезд"
                row.placeholder = "1"
            }
            <<< TextRow("LevelRow"){ row in
                row.title = "Этаж"
                row.placeholder = "6"
            }
            <<< TextRow("CodeRow"){ row in
                row.title = "Код двери"
                row.placeholder = "605"
        }
            +++ Section("")
            <<< ButtonRow("CreateOrderRow"){ row in
                row.title = "Отправить заказ"
                row.cell.selectionStyle = .none
                row.cell.tintColor = UIColor.white
                row.cell.backgroundColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
                }.onCellSelection {_,_ in
                    self.on_clicked_send_order()
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
                print(response.result.value)
                if let json = response.result.value as? [String: Any] {
                    if json["errors"] as? [String: Any] != nil
                    {
                        ShowError().show_error(text: "Мы сожалеем, но что-то пошло не так. Проверьте введенные данные.")
                    }
                    else {
                        self.post_address()
                    }
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
                        if json["errors"] as? [String: Any] != nil
                        {
                            ShowError().show_error(text: "Мы сожалеем, но что-то пошло не так. Проверьте введенные данные.")
                        }
                        else {
                            print(json)
                            let address_id = json["id"] as! Int
                            CreateOrderViewController().post_order(address_id: address_id, delivery_time: self.delivery_time)
                        }
                    }
                    else {
                        ShowError().show_error(text: "Мы сожалеем, но что-то пошло не так. Проверьте пожалуйста соединение с интернетом.")
                    }
                }
                else
                {
                    ShowError().show_error(text: "Мы сожалеем, но что-то пошло не так. Проверьте пожалуйста соединение с интернетом.")
                }
        }
    }
    
    func on_clicked_send_order()
    {
        PageLoading().showLoading()
        if new_profile
        {
            post_profile()
        }
        else {
            post_address()
        }
    }
    
    
    @objc func goto_well_done()
    {
        PageLoading().hideLoading()
        tabBarController?.tabBar.items?[2].badgeValue = "0"
        let controller : WellDoneViewController = self.storyboard?.instantiateViewController(withIdentifier: "WellDoneViewController") as! WellDoneViewController
        self.navigationController?.pushViewController(controller, animated: false)
    }

}
