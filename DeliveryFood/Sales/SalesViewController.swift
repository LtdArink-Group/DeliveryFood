//
//  SalesViewController.swift
//  DeliveryFood
//
//  Created by B0Dim on 28.09.17.
//  Copyright © 2017 B0Dim. All rights reserved.
//

import UIKit
import Alamofire
import ASHorizontalScrollView
import Crashlytics
import Fabric
import Alamofire
import SwiftyJSON

class SalesViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    var search_results = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let requestManager = RequestManagerSales()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        tableView.estimatedRowHeight = 571
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название акции"
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.becomeFirstResponder()
        tableView.tableHeaderView?.becomeFirstResponder()
        tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(SalesViewController.updateSearchResults), name: NSNotification.Name(rawValue: "search_result_sales_updated"), object: nil)
        
        search_results = []
        updateSearchResults()
        requestManager.resetSearch()
        requestManager.search(searchText: searchController.searchBar.text!.lowercased())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateSearchResults() {
        search_results = requestManager.searchResults
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return search_results.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SalesTableViewCell
        cell.img_sale.image = UIImage(named: "burgers" + String(indexPath.row + 1))
        cell.lbl_cost_img.text = String((indexPath.row + 1) * 100)
        cell.txt_sale.text = search_results[indexPath.row] + "\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        cell.btn_additional.tag = indexPath.row + 1
        return cell
    }
    
    private func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.characters.count > 2
        {
            search_results = []
            updateSearchResults()
            requestManager.resetSearch()
            requestManager.search(searchText: searchBar.text!.lowercased())
        }
        else if searchBar.text!.characters.count == 0 {
            search_results = []
            updateSearchResults()
            requestManager.resetSearch()
            requestManager.search(searchText: searchBar.text!.lowercased())
        }
        else {
            //nothing
        }
    }
    @IBAction func on_clicked_additional(_ sender: UIButton) {
//        print(sender.tag)
////        performSegue(withIdentifier: "goto_additional", sender: self)
//        let controller : AdditionalViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdditionalViewController") as! AdditionalViewController
//        controller.img = UIImage(named: "burgers" + String(sender.tag))!
//        controller.txt_cost = String(sender.tag * 100)
//        controller.product = search_results[sender.tag-1] + "\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
//        controller.arr_additionals = ["🥗 Клоу слоу (200гр)","🧀 Сыр чеддер"]
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
    
    
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!
        _ = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
    }
    
    func goToNextView() {
        performSegue(withIdentifier: "goto_additional", sender: self)
    }
}

class RequestManagerSales {
    
    var searchResults = [String]()
    func search(searchText: String)
    {
        self.searchResults = ["бургеры","ноги","крылья"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "search_result_sales_updated"), object: nil)
        
//        var url = server_name + "/sales?title=like.*\(searchText)*&order=title"
//        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        Alamofire.request(.GET, url)
//            .authenticate(user: user_db, password: password_db)
//            .responseJSON { response in
//                if let results = response.result.value as? [AnyObject] {
//                    self.searchResults = []
//                    let item = JSON(results).arrayValue
//                    self.searchResults += item
//                    NSNotificationCenter.defaultCenter().postNotificationName("search_result_sales_updated", object: nil)
//                }
//        }
    }
    
    func resetSearch() {
        searchResults = []
    }
}

