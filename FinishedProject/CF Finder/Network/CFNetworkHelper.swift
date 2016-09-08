//
//  CFNetworkHelper.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//
import Foundation
import CoreLocation

class CFNetworkHelper: NSObject {
    func getNearbyCFsAtCoordinate(coordinate: CLLocationCoordinate2D, withCompletionHandler completionHandler: (CFsArray: NSArray, error: NSError?) -> Void) {
        let stringService = Constants.sharedInstance.getServiceHost(coordinate.latitude, long: coordinate.longitude)
        let url = NSURL(string: stringService)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) { data, response, error in
            if let mydata = data {
                if let cfsArray = NSArray.CFsFromServerData(mydata) {
                    completionHandler(CFsArray: cfsArray, error: error)
                }
            }
        }
        
        task.resume()
    }
    
    func getImageNSDataFromURL(urlString: String, withCompletionHandler completionHandler: (data: NSData) -> Void) {
        let imageURL = NSURL(string: urlString)!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {() -> Void in
            let imageData = NSData(contentsOfURL: imageURL)
            if let data = imageData {
                completionHandler(data: data)
            }
        })
    }
}