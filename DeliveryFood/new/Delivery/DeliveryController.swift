//
//  DeliveryViewController.swift
//  DeliveryFood
//
//  Created by Admin on 26/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Eureka

class DeliveryController: FormViewController {
    class Builder {
        private var nc: UINavigationController!

        private var order: Order?
        private var deliveryCost: Double?
        private var pickupDiscount :Int?
        private var availableTimePeriodForOrder: (sh: Int, sm: Int, eh: Int, em: Int)?
        private var callbackDeliveryDidSent: (()->Void)?
        
        func setOrder(_ value: Order) -> Self {
            order = value
            return self
        }

        init () {}
        
        func setDeliveryCost(_ value: Double) -> Self {
            deliveryCost = value
            return self
        }

        func setPickupDiscountPercentage(_ value: Int) -> Self {
            pickupDiscount = value
            return self
        }

        func setTimePeriod(_ value: (sh: Int, sm: Int, eh: Int, em: Int)) -> Self {
            availableTimePeriodForOrder = value
            return self
        }
        
        func setDeliveryDidSent(_ value: @escaping ()->()) -> Self {
            callbackDeliveryDidSent = value
            return self
        }
        
        private func build() -> Self {
            let storyboard = UIStoryboard(name: "Delivery", bundle: nil)
            nc = storyboard.instantiateViewController(withIdentifier: "deliveryNavigationController") as! UINavigationController
            let vc = nc.viewControllers.first as! DeliveryController
            
            let model = Delivery(order: order ?? Order())
            vc.dc = DeliveryContext(model: model)
            vc.dc.deliveryCost = deliveryCost ?? 0
            vc.dc.pickupDiscount = pickupDiscount ?? 0
            vc.dc.availableTimePeriodForOrder = availableTimePeriodForOrder ?? (sh: 0, sm: 0, eh: 24, em: 59)
            vc.dc.callbackDeliveryDidSent = callbackDeliveryDidSent
            
            return self
        }

        func show(parentController parent: UIViewController) {
            parent.present(build().nc, animated: true, completion: nil)
        }
    }
    
    var dc: DeliveryContext!


    override func viewDidLoad() {
        super.viewDidLoad()
    
        //dump
        if dc == nil {
            dc = DeliveryContext(model: Delivery(order: Order().fillByDummy()))
        }
        
        self.navigationItem.prompt = String(format: "Заказ на сумму %.0f руб.", dc.model.order.summaNetto!)
        tableView.isHidden = true
        createForm()
        fillFields { error in
            if error == nil {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    var earlyTime = true;
    private func createForm() {
        
        form
            
        +++ Section()
            {
                $0.header = {
                    var header = HeaderFooterView<UIView>(.callback({
                        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
                        view.backgroundColor = .white
                        return view
                    }))
                    header.height = { 8 }
                    return header
                }()
            }
            <<< PhoneFloatLabelRow("phone") {
                $0.title = "Телефон"
                $0.placeholder = "Укажите номер телефона"
                $0.add(rule: RuleRequired(msg: "Телефон обязателен к заполнению"))
        }
            <<< NameFloatLabelRow("name") {
                $0.title = "Имя"
                $0.placeholder = "Введите ваше имя"
                }

        +++ Section()
            <<< PickupRow("pickup") {
                $0.discountValue = self.dc.pickupDiscount //todo is not beaty
                }.onChange({ row in
                    //self.form.rowBy(tag: "totalString")?.updateCell()
                })
            +++ Section()
            <<< AddressRow("userAddress") {
                $0.title = "Адрес"
                $0.hidden = Condition.function(["pickup"], {form in
                    return form.rowBy(tag: "pickup")?.value ?? true
                })
                }
                .onCellSelection({ (cell, row) in
                    self.chooseUserAddress()
                })
            <<< AddressRow("companyAddress") {
                $0.title = "Адрес"
                $0.hidden = Condition.function(["pickup"], {form in
                    return !(form.rowBy(tag: "pickup")?.value ?? false)
                })
                }
                .onCellSelection({ (cell, row) in
                    self.chooseCompanyAddress()
                })
            <<< TimeInlineRow("time"){
                $0.cellStyle = UITableViewCellStyle.subtitle
    
                $0.title = "Время (\(Config.Texts.localTimeShortName))"
                $0.hidden = self.earlyTime ? true : false
                
               
                let workTime = (dc.availableTimePeriodForOrder)!
                $0.minuteInterval = 10
                $0.minimumDate = dc.currentDate.setTime(hour: workTime.sh, minute: workTime.sm)
                $0.maximumDate = dc.currentDate.setTime(hour: workTime.eh, minute: workTime.em)
                let suggestTime = dc.currentDate.setTime().addingTimeInterval(Config.Delivery.deliveryOffsetFromCurrentTime * 60).round(precision: Double($0.minuteInterval!) * 60.0, rule: .up)
                
                $0.value = min(max(suggestTime, $0.minimumDate!), $0.maximumDate!) //todo add supply of working from another tz
                //$0.minimumDate = $0.value
                
                }.cellSetup { cell, row in
                    row.dateFormatter?.timeStyle = .short
                    cell.textLabel?.font = .preferredFont(forTextStyle: .caption1)
                    cell.detailTextLabel?.font = .preferredFont(forTextStyle: .body)
                    cell.detailTextLabel?.textColor = self.view.defaultTextColor
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor = row.isExpanded ? cell.tintColor : UIColor.lightGray
                }).onExpandInlineRow({ (cell, inlineRow, pickerRow) in
                    cell.textLabel?.textColor = cell.tintColor
                    let ns = self.form.rowBy(tag: "nearestTimeSwitcher")
                    ns?.hidden = false
                    ns?.evaluateHidden()
                }).onCollapseInlineRow({ (cell, inlineRow, pickerRow) in
                    cell.textLabel?.textColor = UIColor.lightGray
                    let ns = self.form.rowBy(tag: "nearestTimeSwitcher")
                    ns?.hidden = true
                    ns?.evaluateHidden()
                })
            <<< SwitchRow("nearestTimeSwitcher") {
                $0.title = "На ближайшее время"
                $0.value = true
                $0.cell.switchControl.onTintColor = self.view.tintColor
                $0.cell.detailTextLabel?.textColor = self.view.defaultTextColor
                $0.onChange({[unowned self] row in
                    self.earlyTime = row.value!
                    let timeRow = self.form.rowBy(tag: "time")
                    timeRow?.hidden = Condition(booleanLiteral: self.earlyTime)
                    timeRow?.evaluateHidden()
                    row.hidden = Condition(booleanLiteral: !self.earlyTime)
                    self.tableView?.beginUpdates()
                    row.evaluateHidden()
                    self.tableView?.endUpdates()
                    if !self.earlyTime {
                        (timeRow as? TimeInlineRow)?.expandInlineRow()
                    }
                }).onCellSelection({ (cell, row) in
                    row.value = !row.value!
                }).cellUpdate({ (cell, row) in
                    //row.cell.switchControl.isHidden = row.value ?? false
                })
            }
        +++ Section()
//            {
//            $0.header?.title = "Адрес"
//            }
        +++ Section()
            <<< LabelRow()
            <<< TextFloatLabelRow("note") {
                $0.title = "Комментарий"
                $0.placeholder = "Укажите ваши пожелания"
            }

        +++ Section()
            <<< LabelRow("totalString") { row in
                row.hidden = Condition.function(["pickup"], {form in
                    row.title = self.createTotalString()
                    row.updateCell()
                    return row.title == nil
                })
                row.cell.textLabel?.font = .italicSystemFont(ofSize: 13)
                row.cell.textLabel?.numberOfLines = 2
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor = self.view.tintColor
                    cell.textLabel?.textAlignment = .center
                })
        <<< ButtonRow("send") {
            $0.title = "Отправить заказ"
            //$0.cell.selectionStyle = .none
            }.cellUpdate({ (cell, row) in
                cell.backgroundColor = self.view.tintColor //Helper.shared.UIColorFromRGB(rgbValue: UInt(SECOND_COLOR)) //todo unlink from Helper 
                cell.tintColor = UIColor.white
            }).onCellSelection({ (cell, row) in
                if self.form.validate().count == 0 {
                    self.send()
                }
            })

    }
 
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
