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
    var new_profile = false
    var index_address = 0
    var update_row = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.reload_address), name: NSNotification.Name(rawValue: "reload_address"), object: nil)

        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        self.navigationItem.rightBarButtonItem?.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        get_user_info()
    }

    func get_user_info()
    {
        self.addresses = []
        let url = SERVER_NAME + "/api/accounts/" + ID_phone
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                if let json = response.result.value  as? [String: Any] {
                    if json["status"] as? Int == nil
                    {
                        self.name = json["name"] as! String
                        self.email = json["email"] as! String
                        self.phone = json["phone"] as! String
                        self.addresses = json["addresses"] as! [[String: Any]]
                        self.new_profile = false
                        self.create_form()
                    }
                    else
                    {
                        self.new_profile = true
                        self.create_form()
                    }
                }
        }
    }
    
    func get_address_user_info()
    {
        self.addresses = []
        let url = SERVER_NAME + "/api/accounts/" + ID_phone
        print(url)
        Alamofire.request(url, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                if let json = response.result.value  as? [String: Any] {
                    if json["status"] as? Int == nil
                    {
                        self.addresses = json["addresses"] as! [[String: Any]]
                        self.edit_address_form()
                        self.new_profile = false
                        PageLoading().hideLoading()
                    }
                }
        }
    }
    
    @objc func reload_address()
    {
        let section = form[2]
        section.removeAll()
        section.reload()
        form.remove(at: 2)
        get_address_user_info()
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
        PageLoading().showLoading()
        save()
    }

    
    func go_to_address(each: [String: Any], new: Bool)
    {
        let controller : AddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        controller.arr_address = each
        controller.new_address = new
        controller.name = get_name()
        controller.phone = get_phone()
        controller.email = get_email()
        controller.new_profile = new_profile
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func edit_address_form()
    {
        form
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Reorder],
                                   header: "Адреса",
                                   footer: "Вы можете добавить несколько адресов доставки"
            ) {
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Добавить адрес"
//                        $0.cell.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return LabelRow("NewAddressRow\(index)") {
                        $0.title = "Новый адрес"
                        $0.cell.accessoryType = .disclosureIndicator
                        }.onCellSelection {_,_ in
                            Helper().delay(0.5)
                            {
                                self.index_address = index
                                self.go_to_address(each: [:], new: true)
                            }
                        }.cellUpdate { cell, row in
                            if !self.update_row
                            {
                                Helper().delay(0.5)
                                {
                                    self.index_address = index
                                    self.go_to_address(each: [:], new: true)
                                }
                            }
                    }
                }
                for (index, each) in Helper().sort_address(array: addresses).enumerated()
                {
                    $0 <<< LabelRow("AddressRow\(index)") {
                        $0.cell.imageView?.image = UIImage(named: Helper().get_icon(title: (each["title"] as? String)!))
                        $0.title = each["title"] as? String
                        $0.cell.accessoryType = .disclosureIndicator
                        }.onCellSelection {_,_ in
                            self.go_to_address(each: each, new: false)
                            self.index_address = index
                        }
                }
        }
        PageLoading().hideLoading()
        
    }
    
    func get_name() -> String
    {
        let name_row: TextRow = self.form.rowBy(tag: "NameRow")!
        return name_row.value as! String
    }
    
    func get_phone() -> String
    {
        let phone_row: PhoneRow = self.form.rowBy(tag: "PhoneRow")!
        return phone_row.value as! String
    }
    
    func get_email() -> String
    {
        let email_row: EmailRow = self.form.rowBy(tag: "EmailRow")!
        return email_row.value as! String
    }
    
    func save()
    {
        if new_profile == false
        {
            update()
        } else {
            post_without_address()
        }
    }
    
    func post_without_address()
    {
        let url = SERVER_NAME + "/api/accounts/"
        let params = [
            "id": "\(ID_phone)",
            "name": get_name(),
            "phone": get_phone(),
            "email": get_email()
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    self.goto_main()
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_DATA)
                }
        }
    }
    
    func update()
    {
        let url = SERVER_NAME + "/api/accounts/" + ID_phone + "/update"
        let params = [
            "name": get_name(),
            "phone": get_phone(),
            "email": get_email()
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON() { (response) -> Void in
                if response.result.value != nil {
                    self.goto_main()
                }
                else
                {
                    ShowError().show_error(text: ERR_CHECK_DATA)
                }
        }
    }
    
    func goto_main()
    {
        PageLoading().hideLoading()
        let tbc = storyboard?.instantiateViewController(withIdentifier: "mainTabBarController") as? UITabBarController
        tbc?.selectedIndex = 0
        tabBarController?.present(tbc!, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


