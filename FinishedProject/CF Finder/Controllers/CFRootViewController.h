//
//  CFRootViewController.h
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Buy n Large. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface CFRootViewController : UIViewController

-(void) showMessageWithTitle:(NSString *) title andMessage:(NSString *) message;

-(void) getDirectionFrom:(CLLocationCoordinate2D) userLocation to:(CLLocationCoordinate2D) coffeeLocation;

@end
