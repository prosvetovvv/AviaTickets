//
//  TabBarController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 18.03.2021.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor =[UIColor blueColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSArray<UIViewController *> *)createViewControllers {
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray new];
    
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass.circle"] selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle.fill"]];
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map prices" image:[UIImage systemImageNamed:@"mappin.circle"] selectedImage:[UIImage systemImageNamed:@"mappin.circle.fill"]];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    //TicketsTableViewController *favoritesViewController = [[TicketsTableViewController alloc] initFavoriteTicketsController];
    FavoritesTableViewController *favoritesViewController = [FavoritesTableViewController new];
    favoritesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage systemImageNamed:@"star"] selectedImage:[UIImage systemImageNamed:@"star.circle.fill"]];
    UINavigationController *favoriteNavigationController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    
    [controllers addObject:mainNavigationController];
    [controllers addObject:mapNavigationController];
    [controllers addObject:favoriteNavigationController];
    
    return controllers;
}


@end
