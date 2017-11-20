//
//  DeliveryAddressViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 09.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import Eureka
import UIKit
import Alamofire
import Crashlytics
import Fabric

class DeliveryAddressViewController: FormViewController, UINavigationControllerDelegate {

    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var addresses: [[String: Any]] = []
    var form_ready = false
    var address_id = 0
    var new_profile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddressViewController.goto_well_done), name: NSNotification.Name(rawValue: "show_well_done"), object: nil)
        
        get_user_info()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddressViewController.go_to_back), name: NSNotification.Name(rawValue: "well_done1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddressViewController.go_to_back), name: NSNotification.Name(rawValue: "well_done2"), object: nil)
    }

    @objc func go_to_back()
    {
        navigationController?.popViewController(animated: false)
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
    
//    func set_time_to_date(hour: Int, minute: Int) -> Date
//    {
//        let greg = Calendar(identifier: .gregorian)
//        let now = Date()
//        var components = greg.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
//        components.hour = hour
//        components.minute = minute
//        return greg.date(from: components)!
//    }
    
    func create_form()
    {
        
        form
            
            +++ Section("Время доставки")
            <<< TimeInlineRow("DeliveryTimeRow"){
                $0.title = "Выберите время"
                let currentDate = Date()
                $0.cell.textLabel?.textColor = UIColor.black
                $0.value = currentDate.addingTimeInterval(120 * 60)
                $0.maximumDate = currentDate.set_time_to_date(hour: TIME_HOUR_TO, minute: 00)
                $0.minimumDate = currentDate.set_time_to_date(hour: TIME_HOUR_FROM, minute: 00)
                }.cellSetup { cell, row in
                    row.dateFormatter?.timeStyle = .short
            }
            
            +++ Section("Клиент")
            <<< TextRow("NameRow"){ row in
                row.title = "Имя"
                row.placeholder = "Введите ваше имя"
                row.add(rule: RuleMinLength(minLength: 3))
                row.add(rule: RuleMaxLength(maxLength: 50))
                row.add(rule: RuleRequired())
                row.value = name
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.onChange { _ in
                    self.disabled_order_row()
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
                }.onChange { _ in
                    self.disabled_order_row()
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
                }.onChange { _ in
                    self.disabled_order_row()
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
            
            +++ Section("Выберите адрес или добавьте новый") { on in
                for (index, each) in Helper().sort_address(array: addresses).enumerated()
                {
                    address_id = index == 0 ? (each["id"] as? Int)! : address_id
                   on <<< CheckRow("AddressRow\(index)") {
                        $0.cell.imageView?.image = UIImage(named: Helper().get_icon(title: (each["title"] as? String)!))
                        $0.title = each["title"] as? String
                        $0.value = index == 0
                        $0.cell.tag = index
                    $0.cell.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
                    }.onCellSelection { row, cell in
                        self.set_selected_address(tag: row.tag)
                    }
                }
                on <<< LabelRow("AddAddressRow") {
                    $0.cell.imageView?.image = UIImage(named: "btn_add_row")!
                    $0.title = "Добавить"
                    $0.cell.accessoryType = .disclosureIndicator
                    }.onCellSelection {_,_ in
                        self.on_clicked_add_address()
                }
                        
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
        form_ready = true
        self.disabled_order_row()
    }
    
    func disabled_order_row()
    {
        if form_ready
        {
            let btn: ButtonRow = self.form.rowBy(tag: "CreateOrderRow")!
            if !self.check_contacts_address()
            {
                btn.cell.backgroundColor = UIColor.gray
                btn.disabled = false
                btn.updateCell()
            }
            else {
                btn.cell.backgroundColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
                btn.disabled = true
                btn.updateCell()
            }
        }
    }
    
    func set_selected_address(tag: Int)
    {
        var sort_address = Helper().sort_address(array: addresses)
        address_id = sort_address[tag]["id"] as! Int
        for (index, _) in sort_address.enumerated()
        {
            if tag != index
            {
                let chk_row: CheckRow = self.form.rowBy(tag: "AddressRow\(index)")!
                chk_row.value = false
                chk_row.updateCell()
                self.disabled_order_row()
            }
        }
    }
    
    func get_selected_address() -> Bool
    {
        var index = 0
        while index < Helper().sort_address(array: addresses).count
        {
            let chk_row: CheckRow = self.form.rowBy(tag: "AddressRow\(index)")!
            if chk_row.value == true {
                return true
            }
            index += 1
        }
        return false
    }
    
    func get_delivery_time() -> String
    {
        let time_row: TimeInlineRow = self.form.rowBy(tag: "DeliveryTimeRow")!
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateFromString = formatter.string(from: time_row.value!)
        return dateFromString
    }
    
    func get_name() -> String
    {
        let name_row: TextRow = self.form.rowBy(tag: "NameRow")!
        let str = name_row.value == nil ? "" : name_row.value
        return str!
    }
    
    func get_phone() -> String
    {
        let phone_row: PhoneRow = self.form.rowBy(tag: "PhoneRow")!
        let str = phone_row.value == nil ? "" : phone_row.value
        return str!
    }
    
    func get_email() -> String
    {
        let email_row: EmailRow = self.form.rowBy(tag: "EmailRow")!
        let str = email_row.value == nil ? "" : email_row.value
        return str!
    }
    
    func check_contacts_address() -> Bool
    {
        return check_contacts() && get_selected_address()
    }
    
    func check_contacts() -> Bool
    {
        name = get_name()
        phone = get_phone()
        email = get_email()
        let email_row: EmailRow = self.form.rowBy(tag: "EmailRow")!
        let phone_row: PhoneRow = self.form.rowBy(tag: "PhoneRow")!
        let name_row: TextRow = self.form.rowBy(tag: "NameRow")!
        return name.characters.count > 2 && phone.characters.count > 6 && email.characters.count > 5 && name_row.isValid && phone_row.isValid && email_row.isValid
    }
    
    func on_clicked_send_order()
    {
        if check_contacts_address() == false
        {
            print("error")
            PageLoading().showLoading()
            ShowError().show_error(text: "Проверьте введенные данные и выберите адрес доставки.")
        }
        else {
            print("click")
            PageLoading().showLoading()
            CreateOrderViewController().post_order(address_id: address_id, delivery_time: get_delivery_time())
        }
    }
    
    func on_clicked_add_address()
    {
        if check_contacts() == false {
            PageLoading().showLoading()
            ShowError().show_error(text: "Не верно заполнены контактные данные. Пожалуйста проверьте их.")
        }
        else {
            let controller : DeliveryAddAddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryAddAddressViewController") as! DeliveryAddAddressViewController
            controller.name = get_name()
            controller.phone = get_phone()
            controller.email = get_email()
            controller.delivery_time = get_delivery_time()
            controller.new_profile = new_profile
            self.navigationController?.pushViewController(controller, animated: true)
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
