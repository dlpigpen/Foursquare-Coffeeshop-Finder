// The output below is limited by 1 KB.
// Please Sign Up (Free!) to remove this limitation.

//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//
import Foundation
import UIKit

extension NSArray {
    
        class func CFsFromServerData(data: NSData) -> NSArray? {

            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
                guard let JSONDictionary :NSDictionary = jsonData as? NSDictionary else {
                    print("Not a Dictionary")
                    // put in function
                    return .None
                }
                //print("JSONDictionary! \(JSONDictionary)")
                let json = JSON(JSONDictionary)

                let response = json["response"]["venues"]
                if response.count < 1 {
                    return .None
                }
                
                let cfsArray: NSMutableArray = NSMutableArray()
                for position in 0..<response.count {
                    let cfDictionary: NSMutableDictionary = NSMutableDictionary()
                    
                    let responseItem =  response[position]
                    let location =      responseItem["location"]
                    let contact =       responseItem["contact"]
                    let categories =    responseItem["categories"]
                    
                    cfDictionary["id"] = responseItem["id"].toString() ?? ""
                    cfDictionary["name"] = responseItem["name"].toString() ?? ""
                    cfDictionary["address"] = location["address"].asString ?? ""
                    cfDictionary["formattedAddress"] = location["formattedAddress"].toString() ?? ""
                    cfDictionary["distance"] = location["distance"].asNumber ?? ""
                    cfDictionary["latitud"] = location["lat"].toString() ?? ""
                    cfDictionary["longitud"] = location["lng"].toString() ?? ""
                    cfDictionary["formattedPhone"] = contact["formattedPhone"].asString ?? ""
                    
                    if categories.count > 0 {
                        let firstCategoryIcon = categories[0]["icon"]
                        cfDictionary["categoryName"] = categories[0]["name"].asString ?? ""
                        cfDictionary["categoryIconURL"] = "\(firstCategoryIcon["prefix"])88\(firstCategoryIcon["suffix"])"
                    }
                    cfsArray.addObject(cfDictionary)
                }
                
                return cfsArray

            }
            catch let JSONError as NSError {
                print("\(JSONError)")
            }
        return .None
    }
}

extension NSObject {
    
    func valueOrNil() -> AnyObject {
        if self.dynamicType === NSNull.self {
            return self.copy()
        }
        return ""
    }
}

extension UIView {
    func superviewOfType() -> UIView? {
        guard let superview = self.superview else {
            return .None
        }
        
        
        if superview is CFPinAnnotationView {
            return superview
        }
        
        return superview.superviewOfType()
    }
}
