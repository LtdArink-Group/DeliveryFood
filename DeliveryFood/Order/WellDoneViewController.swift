//
//  WellDoneViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 10.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import CountdownLabel

class WellDoneViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var img_well_done: UIImageView!
    @IBOutlet weak var txt_well_done: UILabel!
    @IBOutlet weak var btn_ok: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        scrl_main.delegate = self
        
        init_form()
    }
    
    func init_form()
    {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        scrl_main.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrl_main.contentSize = CGSize(width: width, height: height + 1)
        
        img_well_done.frame = CGRect(x: (width/2) - 50, y: height/7, width: 100, height: 100)
        txt_well_done.frame = CGRect(x: 20, y: img_well_done.frame.origin.y + 150, width: width - 40, height: 127)
        btn_ok.frame = CGRect(x: (width/2) - 50, y: height - 125 - 44, width: 100, height: 44)
        
//        let frame = CGRect(x: 60, y: 10, width: 100, height: 50)
//        let countdownLabel = CountdownLabel(frame: frame, minutes: 30)
//        scrl_main.addSubview(countdownLabel)
//        countdownLabel.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func on_clicked_btn_ok(_ sender: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "remove_order"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "well_done1"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "order_done"), object: nil)
    }
    

}
