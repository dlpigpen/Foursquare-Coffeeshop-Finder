//
//  CFPinAnnotationView.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class CFPinAnnotationView: MKPinAnnotationView {
    var minWalkLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let myleftCalloutAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height + 11))
        myleftCalloutAccessoryView.backgroundColor = UIColor.redColor()
        
        myleftCalloutAccessoryView.backgroundColor = Constants.sharedInstance.UIColorFromRGB(Constants.sharedInstance.RGB_RED)
        let imageView = UIImageView(image: UIImage(named: "walkIcon")!)
        imageView.center = CGPoint(x: myleftCalloutAccessoryView.center.x, y: myleftCalloutAccessoryView.center.y - 5)
        myleftCalloutAccessoryView.addSubview(imageView)
        minWalkLabel = UILabel(frame: CGRect(x: 0, y: myleftCalloutAccessoryView.frame.size.height - 15, width: 40, height: 10))
        minWalkLabel.font = UIFont(name: Constants.sharedInstance.FONT_HELVETICA_MEDIUM, size: 8)
        minWalkLabel.textColor = UIColor.whiteColor()
        minWalkLabel.textAlignment =  .Center
        myleftCalloutAccessoryView.addSubview(minWalkLabel)
        self.updateMinWalkLabelText()
        
        
        self.leftCalloutAccessoryView = myleftCalloutAccessoryView
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    
    func updateMinWalkLabelText() {
        let annotation: CFMapAnnotation = self.annotation as! CFMapAnnotation
        minWalkLabel.text = "\(annotation.distance!) mts"
    }
    
    
}