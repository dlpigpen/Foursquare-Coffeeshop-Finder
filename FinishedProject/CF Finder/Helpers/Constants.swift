//
//  Constants.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Constants {
    static let sharedInstance = Constants()
    
    // FOURSQUARE
    let SERVICE_HOST = "https://api.foursquare.com/v2/venues/search?client_id=PWS55XITBPEMFL041SC5BC1YVFABXGL5KRHFVOHZ0PDXW5WY&client_secret=X5RA0VO1FK0F0DYR54ZLRBIB33TOOJ2JGGMEGY2PFBMJGOGK&v=20130815&ll="
    
    func getServiceHost(lat: CLLocationDegrees, long: CLLocationDegrees) -> String {
        return "\(SERVICE_HOST)\(lat),\(long)&query=coffee"
    }
    
    // CF RGB COLORS
    let RGB_RED = 0xD0021B
    let RGB_GRAY = 0xC7C7C7
    
    // UICOLOR FROM RGB
    func UIColorFromRGB(rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // FONTS
    let FONT_HELVETICA_REGULAR = "HelveticaNeue"
    let FONT_HELVETICA_MEDIUM  = "HelveticaNeue-Medium"
    let FONT_HELVETICA_LIGHT   = "HelveticaNeue-Light"

    // OTHER VALUES
    let ONE_MILE = 1609344
}
