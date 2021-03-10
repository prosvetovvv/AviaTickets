//
//  PlaceViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 07.03.2021.
//

#import "PlaceViewController.h"
#import "City.h"
#import "Airport.h"
#import "ATPlaceCell.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type
{
    self = [super init];
    if (self) {
        self.placeType = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelf];
    [self setupTableView];
    [self setupSegmentedControl];
    [self changeSource];
}

#pragma mark - Private

- (void)changeSource
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            self.currentArray = [[DataManager sharedInstance] airports];
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setup UI

- (void)setupSelf
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if (self.placeType == PlaceTypeDeparture) {
        self.title = @"Departure";
    } else {
        self.title = @"Arrival";
    }
}

- (void) setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setupSegmentedControl
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    self.navigationItem.titleView = self.segmentedControl;
    self.segmentedControl.tintColor = [UIColor blackColor];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (ATPlaceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ATPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];

    if (!cell) {
        cell = [[ATPlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier placeType:self.placeType];
    }
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            City *city = [self.currentArray objectAtIndex:indexPath.row];
            [cell setWith:city.name and:city.code];
            break;
        }
            
        case 1:
        {
            Airport *airport = [self.currentArray objectAtIndex:indexPath.row];
            [cell setWith:airport.name and:airport.code];
            break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = (int)self.segmentedControl.selectedSegmentIndex + 1;
    
    [self.delegate selectPlace:[self.currentArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
