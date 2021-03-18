//
//  AppDelegate.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    
    //MainViewController *mainViewController = [MainViewController new];
    //MapViewController *mapViewController = [MapViewController new];
    
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    TabBarController *tabBarController = [TabBarController new];
    
    //self.window.rootViewController = navigationController;
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
