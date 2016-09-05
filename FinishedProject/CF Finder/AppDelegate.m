//
//  AppDelegate.m
//  CF Finder
//
//  Created by Duc Nguyen on 02/07/2016.
//  Copyright (c) 2016 Duc Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "CFViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *newRootViewController = [storyboard instantiateInitialViewController];
    [self.window setRootViewController:newRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
