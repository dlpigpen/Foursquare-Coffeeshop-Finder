//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import "CFMapAnnotation.h"

@implementation CFMapAnnotation

-(NSString *)title
{
    return self.name;
}

-(NSString *)subtitle
{
    return self.address;
}

@end
