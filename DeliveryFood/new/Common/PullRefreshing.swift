//
//  PullRefreshing.swift
//  DeliveryFood
//
//  Created by Admin on 05/08/2018.
//  Copyright © 2018 B0Dim. All rights reserved.
//

import Foundation
import UIKit

class PullRefreshing {
    
    let refreshControl = UIRefreshControl()
    var tableView: UITableView!
    var action: ()->()!
    
    init(tableView: UITableView, action: @escaping ()->()) {
 
        self.tableView = tableView
        self.action = action
        refreshControl.addTarget(self, action: (#selector(refresh(_:))), for: .valueChanged)

        self.attachRefreshConrol()
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        action()
        
        
    }
    
    var isEnabled = true {
        didSet {
            refreshControl.endRefreshing()
            attachRefreshConrol()
        }

    }
    
    func attachRefreshConrol () {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = isEnabled ? refreshControl : nil
        } else {
            self.tableView.backgroundView = isEnabled ? refreshControl : nil
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showErrorMessage() {
        refreshControl.endRefreshing()
        hideErrorMessage()
        

        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView.image = UIImage(named: "bad_connection");
        imageView.contentMode = .scaleAspectFit

        let noDataLabel = UILabel()
        noDataLabel.numberOfLines = 5
        noDataLabel.text          = "Нет соединения,\nпожайлуста попробуйте позже!"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center

        let noDataLabel2 = UILabel()
        noDataLabel2.numberOfLines = 1
        noDataLabel2.text          = "(Вы можете обновить форму потянув ее вниз)"
        noDataLabel2.font = noDataLabel2.font.withSize(12)
        noDataLabel2.textAlignment = .center

        let captionView = UIStackView();
        captionView.axis = .vertical

        captionView.addArrangedSubview(imageView)
        captionView.addArrangedSubview(noDataLabel)
        captionView.addArrangedSubview(noDataLabel2)

        captionView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.addSubview(captionView)
        captionView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        captionView.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        captionView.widthAnchor.constraint(equalToConstant: self.tableView.bounds.size.width).isActive = true

        self.tableView.separatorStyle  = .none
    }
    
    func hideErrorMessage() {
        self.tableView.subviews.forEach { (view) in
            if view is UIStackView {
                view.removeFromSuperview()
            }
        }
        self.tableView.separatorStyle  = .singleLine
    }
    
}
