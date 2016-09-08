//
//  SearchController.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewDelegate: NSObjectProtocol {
    func didSelectRow(cfDictionay: CFMapAnnotation)
}

class SearchController: UITableViewController {
    var arrData = [AnyObject]()
    var delegate: SearchViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier) as UITableViewCell

        }
        let cfShop = self.arrData[indexPath.row] as! CFMapAnnotation
        cell!.textLabel!.text = cfShop.name as String
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cfShop = self.arrData[indexPath.row] as! CFMapAnnotation
        
        if let mydelegate = self.delegate {
            mydelegate.didSelectRow(cfShop)
        }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}