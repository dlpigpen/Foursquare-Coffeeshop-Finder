//
//  DetailCFTableViewCell.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit

class DetailCFTableViewCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let constant = Constants.sharedInstance
        
        // Fonts
        self.leftLabel.font = UIFont(name: constant.FONT_HELVETICA_LIGHT, size: 15)
        self.rightLabel.font = UIFont(name: constant.FONT_HELVETICA_MEDIUM, size: 16)
        // Text Color
        self.leftLabel.textColor = constant.UIColorFromRGB(constant.RGB_RED)
        self.rightLabel.textColor = constant.UIColorFromRGB(constant.RGB_GRAY)
    }
}
