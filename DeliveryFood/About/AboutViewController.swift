//
//  AboutViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 22.11.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
import GoogleMaps

class AboutViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var scrl_main: UIScrollView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var btn_phone: UIButton!
    @IBOutlet weak var lbl_clock: UILabel!
    @IBOutlet weak var btn_feedback: UIButton!
    @IBOutlet weak var img_phone: UIImageView!
    @IBOutlet weak var img_clock: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        GMSServices.provideAPIKey(MAP_KEY)
        
        create_form()
    }
    
    func create_form()
    {
        let width = UIScreen.main.bounds.size.width
        img_logo.frame = CGRect(x: (width - img_logo.frame.width)/2, y: 24, width: img_logo.frame.width, height: img_logo.frame.height)
        var height = img_logo.frame.height + 32
        lbl_info.text = COMPANY_INFO
        lbl_info.lineBreakMode = NSLineBreakMode.byWordWrapping
        let countline = lbl_info.numberOfVisibleLines
        
        lbl_info.numberOfLines = countline + 1
        lbl_info.frame = CGRect(x: 16, y: height, width: width - 32, height: CGFloat(countline * 25))
        height = height + CGFloat(countline * 25) + 14
        img_phone.frame = CGRect(x: 16, y: height, width: img_phone.frame.width, height: img_phone.frame.height)
        btn_phone.frame = CGRect(x: 16 + img_phone.frame.width + 10, y: height, width: 280, height: btn_phone.frame.height)
        height = height + img_phone.frame.height + 18
        img_clock.frame = CGRect(x: 16, y: height, width: img_clock.frame.width, height: img_clock.frame.height)
        lbl_clock.frame = CGRect(x: 16 + img_clock.frame.width + 10, y: height, width: width - 32, height: lbl_clock.frame.height)
        height = height + lbl_clock.frame.height + 16
        
        let cgrect = CGRect(x: 16, y: height, width: width - 32, height: (width - 32) * 0.7)
        let center_map = CENTER_MAP.split(separator: ",")
        let camera = GMSCameraPosition.camera(withLatitude: Double(center_map[0])!, longitude: Double(center_map[1])!, zoom: 12)
        let mapView = GMSMapView.map(withFrame: cgrect, camera: camera)
        for each in GEOTAG
        {
            let geotag = each.split(separator: ",")
            let cur_loc = CLLocationCoordinate2D(latitude: Double(geotag[0])!, longitude: Double(geotag[1])!)
            let marker_chixx = GMSMarker(position: cur_loc)
            marker_chixx.title = "Доставка Chixx"
            marker_chixx.map = mapView
            marker_chixx.icon = UIImage(named: "icon_truck")
            marker_chixx.appearAnimation = .pop
        }
        for each in GEOTAG_CAFE
        {
            let geotag = each.split(separator: ",")
            let cur_loc = CLLocationCoordinate2D(latitude: Double(geotag[0])!, longitude: Double(geotag[1])!)
            let marker_chixx = GMSMarker(position: cur_loc)
            marker_chixx.title = "Кафе Chixx"
            marker_chixx.map = mapView
            marker_chixx.icon = UIImage(named: "icon_burger")
            marker_chixx.appearAnimation = .pop
        }
        mapView.settings.zoomGestures = true
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.gray.cgColor
        scrl_main.addSubview(mapView)
        
        height = height + (width - 32) * 0.7 + 40
        btn_feedback.frame = CGRect(x: (width - btn_feedback.frame.width)/2, y: height, width: btn_feedback.frame.width, height: btn_feedback.frame.height)
        height = height + btn_feedback.frame.height
        height = width == 320 ? height + 70 : height
        scrl_main.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: Helper().scrl_height(height: height, height_screen: UIScreen.main.bounds.size.height))
        
        btn_phone.setTitle(PHONE, for:.normal)
        let minutes_from = WORK_MINUTES_FROM == 0 ? "00" : String(WORK_MINUTES_FROM)
        let minutes_to = WORK_MINUTES_TO == 0 ? "00" : String(WORK_MINUTES_TO)
        lbl_clock.text = "\(WORK_HOUR_FROM):\(minutes_from) - \(WORK_HOUR_TO):\(minutes_to)" + TIME_ZONE_TITLE
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func on_click_btn_phone(_ sender: UIButton) {
        let phone:NSURL = NSURL(string: "tel://\(PHONE.digits)")!
        UIApplication.shared.openURL(phone as URL)
    }
    
    @IBAction func on_clicked_btn_feedback(_ sender: UIButton) {
        send_email()
    }
    
    //MARK: Email
    func send_email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(COMPANY_EMAIL)
            mail.setMessageBody(FEEDBACK_TXT, isHTML: false)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}



