//
//  Coffeeshop Finder
//
//  Created by Duc Nguyen on 9/5/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.

#import <UIKit/UIKit.h>
#import "CFMapAnnotation.h"

@protocol SearchViewDelegate <NSObject>

- (void) didSelectRow:(CFMapAnnotation *) cfDictionay;

@end

@interface SearchController : UITableViewController

@property (nonatomic,strong) NSArray * arrData;
@property (nonatomic, weak) id<SearchViewDelegate> delegate;

@end
