//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CFMapAnnotation: NSObject <MKAnnotation>

@property (nonatomic) NSString *identifier;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSString *address;
@property (nonatomic) NSArray *formattedAddress;
@property (nonatomic) NSString *formattedPhone;;
@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSString *categoryIconURL;
@property (nonatomic) UIImage *categoryIcon;

@end
