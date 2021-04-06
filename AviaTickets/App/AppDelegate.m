//
//  AppDelegate.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    
    TabBarController *tabBarController = [TabBarController new];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [[NotificationCenter sharedInstance] registerService];
    
    return YES;
}

@end
