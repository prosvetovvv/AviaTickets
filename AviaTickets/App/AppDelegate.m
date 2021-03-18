//
//  AppDelegate.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FirstCollectionController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    
    //MainViewController *mainViewController = [MainViewController new];
    FirstCollectionController *firstCollectionController = [FirstCollectionController new];
    
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstCollectionController];
    
    //self.window.rootViewController = navigationController;
    self.window.rootViewController = firstNavigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
