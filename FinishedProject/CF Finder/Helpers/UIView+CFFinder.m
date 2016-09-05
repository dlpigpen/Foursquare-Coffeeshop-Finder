//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import "UIView+CFFinder.h"

@implementation UIView (CFFinder)

-(UIView *)superviewOfType:(Class)superviewClass
{
    if (!self.superview){
        return nil;
    }
    if ([self.superview isKindOfClass:superviewClass]){
        return self.superview;
    }
    return [self.superview superviewOfType:superviewClass];
}

@end
