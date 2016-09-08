//
//  CFRootViewController.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CFRootViewController: UIViewController {
    
    var constants = Constants.sharedInstance
    
    func showMessageWithTitle(title: NSString, message: NSString) {
        let alertController = UIAlertController(title: title as String, message: message as String, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getDirectionFrom(userLocation: CLLocationCoordinate2D, coffeeLocation: CLLocationCoordinate2D) {
        let formatDirectionString = "http://maps.apple.com/?daddr=\(userLocation.latitude),+\(userLocation.longitude)&saddr=\(coffeeLocation.latitude),+\(coffeeLocation.longitude)"
        
        if let url = NSURL(string: formatDirectionString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}