//
//  CFMapAnnotation.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import MapKit

class CFMapAnnotation: NSObject, MKAnnotation {
    
    var identifier: NSString?
    var coordinate: CLLocationCoordinate2D
    var name: NSString
    var distance: NSNumber?
    var address: NSString
    var formattedAddress: NSString?
    var formattedPhone: NSString?
    var categoryName: NSString?
    var categoryIconURL: NSString?
    var categoryIcon: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: NSString, subtitle: NSString) {
        self.coordinate = coordinate
        self.name = title
        self.address = subtitle
    }
    
    var title: String? {
        get {
            return self.name as String
        }
    }
    
    var subtitle: String? {
        get {
            return self.address as String
        }
    }
    
    var getAddressString: String {
        get {
            if let myAddress = self.formattedAddress {
                var str = myAddress.stringByReplacingOccurrencesOfString("[", withString: "")
                str = str.stringByReplacingOccurrencesOfString("]", withString: "")
                str = str.stringByReplacingOccurrencesOfString("\"", withString: "")
                str = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                print("[CFMapAnnotation]",  str)
                return str
            }
            return ""
        }
    }
}