//
//  ViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 18.12.2017.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var scrlMain: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrlMain.delegate = self
        scrlMain.contentSize = CGSize(width: scrlMain.contentSize.width, height: scrlMain.contentSize.height + 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validationText(_ sender: UITextField) {
        print(textView.text!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
