//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import "NSObject+CFFinder.h"

@implementation NSObject (CFFinder)

-(id)valueOrNil
{
    return [self isMemberOfClass:[NSNull class]] ? nil : [self copy];
}
@end
