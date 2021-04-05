//
//  FavoritesTableViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 24.03.2021.
//

#import "FavoritesTableViewController.h"

#define ReuseIdentifier @"CellIdentifier"

@interface FavoritesTableViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentTickets;
@property (nonatomic, strong) TicketCell *selectedCell;

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSelf];
    [self setupSegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self changeSource];
}

#pragma mark - Private

- (void)changeSource {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentTickets = [[CoreDataManager sharedInstance] favorites];
            break;
        case 1:
            self.currentTickets = [[CoreDataManager sharedInstance] mapTickets];
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Setup UI

- (void)setupSelf {
    self.title = TitleFavoritesTableViewController;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.tableView registerClass:[TicketCell class] forCellReuseIdentifier:ReuseIdentifier];
}

- (void)setupSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[SegmentItemSearch , SegmentItemMap]];
    self.navigationItem.titleView = self.segmentedControl;
    self.segmentedControl.tintColor = [UIColor blackColor];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            cell.favoriteTicket = self.currentTickets[indexPath.row];
            break;
        case 1:
            cell.mapTicket = self.currentTickets[indexPath.row];
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCell) {
        self.selectedCell.isSelected = NO;
    }
    
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell.isSelected = YES;
}

@end
