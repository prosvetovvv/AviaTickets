//
//  TabBarController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 22.03.2021.
//

#import "TabBarController.h"
#import "CollectionViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    CollectionViewController *firstController = [[CollectionViewController alloc] init];
    firstController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Tab1" image:[UIImage systemImageNamed:@"house"] selectedImage:[UIImage systemImageNamed:@"house.circle"]];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:firstController];
    
    CollectionViewController *secondViewController = [[CollectionViewController alloc] init];
    secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен" image:[UIImage systemImageNamed:@"house"] selectedImage:[UIImage systemImageNamed:@"house.circle"]];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    [controllers addObject:firstNavigationController];
    [controllers addObject:secondNavigationController];
    
    return controllers;
}



@end
