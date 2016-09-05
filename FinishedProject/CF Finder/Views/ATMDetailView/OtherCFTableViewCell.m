//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import "OtherCFTableViewCell.h"
#import "Constants.h"

@implementation OtherCFTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];

    // Fonts
    [self.nameLabel setFont:[UIFont fontWithName:FONT_HELVETICA_MEDIUM size:16]];
    [self.addressLabel setFont:[UIFont fontWithName:FONT_HELVETICA_REGULAR size:16]];
    
    // Text Color
    [self.addressLabel setTextColor:UIColorFromRGB(RGB_GRAY)];
    
    // Corner Radius
    [self.categoryIconImageView.layer setCornerRadius:5];
    [self.categoryIconImageView setClipsToBounds:YES];
    [self.categoryIconImageView setBackgroundColor:UIColorFromRGB(RGB_GRAY)];
}


@end
