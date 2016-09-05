//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import "DetailCFTableViewCell.h"
#import "Constants.h"

@implementation DetailCFTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // Fonts
    [self.leftLabel setFont:[UIFont fontWithName:FONT_HELVETICA_LIGHT size:15]];
    [self.rightLabel setFont:[UIFont fontWithName:FONT_HELVETICA_MEDIUM size:16]];
    
    // Text Color
    [self.leftLabel setTextColor:UIColorFromRGB(RGB_RED)];
    [self.rightLabel setTextColor:UIColorFromRGB(RGB_GRAY)];
}
@end
