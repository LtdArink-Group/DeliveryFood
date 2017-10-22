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
import Crashlytics
import Fabric
class AddressViewController: FormViewController {
    
    @IBOutlet weak var btn_bar: UIBarButtonItem!
    
    var arr_address: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        create_form()
    }

    func create_form()
    {
        
        form

            +++ Section("Адрес")
            <<< TextRow("NameAddressRow"){ row in
                row.title = "Название адреса"
                row.placeholder = "Домашний"
                row.value = arr_address.count > 0 ? arr_address["title"] as! String: ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("AddressRow"){ row in
                row.title = "Улица"
                row.placeholder = "Ленинградская"
                row.value = arr_address.count > 0 ? arr_address["street"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("HouseRow"){ row in
                row.title = "Дом"
                row.placeholder = "26"
                row.value = arr_address.count > 0 ? arr_address["house"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("FlatRow"){ row in
                row.title = "Квартира/офис"
                row.placeholder = "605"
                row.value = arr_address.count > 0 ? arr_address["office"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("GrandRow"){ row in
                row.title = "Подъезд"
                row.placeholder = "1"
                row.value = arr_address.count > 0 ? arr_address["entrance"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("LevelRow"){ row in
                row.title = "Этаж"
                row.placeholder = "6"
                row.value = arr_address.count > 0 ? arr_address["floor"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
            }
            <<< TextRow("CodeRow"){ row in
                row.title = "Код двери"
                row.placeholder = "605"
                row.value = arr_address.count > 0 ? arr_address["code"] as! String : ""
                }.onChange { row in
                    self.btn_bar.title = "Сохранить"
        }
    }
    
    @IBAction func on_clicked_btn_save(_ sender: UIBarButtonItem) {
        post_address()
    }
    
    func post_address()
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

