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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = Helper().UIColorFromRGB(rgbValue: UInt(FIRST_COLOR))
        create_form()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryAddressViewController.go_to_back), name: NSNotification.Name(rawValue: "well_done1"), object: nil)
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
    
    func on_clicked_send_order()
    {
        goto_well_done()
    }
    
    func goto_well_done()
    {
        let controller : WellDoneViewController = self.storyboard?.instantiateViewController(withIdentifier: "WellDoneViewController") as! WellDoneViewController
        self.navigationController?.pushViewController(controller, animated: false)
    }

}
