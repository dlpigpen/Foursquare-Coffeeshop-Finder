//
//  OtherCFTableViewCell.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit

class OtherCFTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 
        let constant = Constants.sharedInstance
        
        // Fonts
        self.nameLabel.font = UIFont(name: constant.FONT_HELVETICA_MEDIUM, size: 16)
        self.addressLabel.font = UIFont(name: constant.FONT_HELVETICA_REGULAR, size: 16)
        // Text Color
        self.addressLabel.textColor = constant.UIColorFromRGB(constant.RGB_GRAY)
        // Corner Radius
        self.categoryIconImageView.layer.cornerRadius = 5
        self.categoryIconImageView.clipsToBounds = true
        self.categoryIconImageView.backgroundColor = constant.UIColorFromRGB(constant.RGB_GRAY)
    }
}