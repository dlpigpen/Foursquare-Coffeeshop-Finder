//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CFNetworkHelper : NSObject

- (void)getNearbyCFsAtCoordinate:(CLLocationCoordinate2D)coordinate
            withCompletionHandler:(void (^)(NSArray *CFsArray, NSError *error))completionHandler;

-(void)getImageNSDataFromURL:(NSString *)urlString
       withCompletionHandler:(void (^)(NSData *data))completionHandler;

@end
