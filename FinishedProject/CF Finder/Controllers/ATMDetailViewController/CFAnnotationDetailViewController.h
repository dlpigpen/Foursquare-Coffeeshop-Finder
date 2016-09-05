//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMapAnnotation.h"
#import "CFRootViewController.h"

@interface CFAnnotationDetailViewController : CFRootViewController

@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic) CFMapAnnotation *annotation;
@property (nonatomic) NSArray *nearAnnotations;

@end
