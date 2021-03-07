//
//  ViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    [self setupSelf];
    
}


- (void)setupSelf {
    self.title = @"Main";
    self.view.backgroundColor = [UIColor greenColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}


- (void)loadDataComplete
{
    self.view.backgroundColor = [UIColor yellowColor];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

@end
