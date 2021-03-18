//
//  ViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "MainViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *placeContainerView;

@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    
    [self setupSelf];
    [self setupPlaceContainerView];
    [self setupDepartureButton];
    [self setupArrivalButton];
    [self setupSearchButton];
}

#pragma mark - Setup UI

- (void)setupSelf {
    self.title = @"Search";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)setupPlaceContainerView {
    CGRect frame = CGRectMake(20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0);
    self.placeContainerView = [[UIView alloc] initWithFrame:frame];
    self.placeContainerView.backgroundColor = [UIColor whiteColor];
    self.placeContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor];
    self.placeContainerView.layer.shadowOffset = CGSizeZero;
    self.placeContainerView.layer.shadowRadius = 20.0;
    self.placeContainerView.layer.shadowOpacity = 1.0;
    self.placeContainerView.layer.cornerRadius = 10.0;
    
    [self.view addSubview:self.placeContainerView];
}

- (void) setupDepartureButton {
    CGRect frame = CGRectMake(10.0, 20.0, _placeContainerView.frame.size.width - 20.0, 60.0);
    self.departureButton = [[UIButton alloc] initWithFrame:frame];
    self.departureButton.layer.cornerRadius = 10;
    self.departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.departureButton.tintColor = [UIColor blackColor];
    [self.departureButton setTitle:@"Departure" forState: UIControlStateNormal];
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.placeContainerView addSubview:self.departureButton];
}

- (void) setupArrivalButton {
    CGRect frame = CGRectMake(10.0, CGRectGetMaxY(_departureButton.frame) + 10.0, self.placeContainerView.frame.size.width - 20.0, 60.0);
    self.arrivalButton = [[UIButton alloc] initWithFrame:frame];
    self.arrivalButton.layer.cornerRadius = 10;
    self.arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.arrivalButton.tintColor = [UIColor blackColor];
    [self.arrivalButton setTitle:@"Arrival" forState: UIControlStateNormal];
    [self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.placeContainerView addSubview:self.arrivalButton];
}

- (void)setupSearchButton {
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(self.placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.searchButton.tintColor = [UIColor whiteColor];
    self.searchButton.backgroundColor = [UIColor blackColor];
    self.searchButton.layer.cornerRadius = 8.0;
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [self.searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
}


#pragma mark - Private

- (void)placeButtonDidTap:(UIButton *)sender
{
    PlaceViewController *placeViewController;
    
    if ([sender isEqual:self.departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
    }
    
    placeViewController.delegate = self;
    [self.navigationController pushViewController:placeViewController animated:YES];
    
}

- (void)searchButtonDidTap:(UIButton *)sender {
    [[APIManager sharedInstance] ticketsWithRequest:self.searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsTableViewController *ticketsTableViewController = [[TicketsTableViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsTableViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Увы!" message:@"По данному направлению билетов не найдено" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button
{
    NSString *title;
    NSString *iata;
    
    switch (dataType) {
        case DataSourceTypeCity:
        {
            City *city = (City *)place;
            title = city.name;
            iata = city.code;
            break;
        }
            
        case DataSourceTypeAirport:
        {
            Airport *airport = (Airport *)place;
            title = airport.name;
            iata = airport.cityCode;
            break;
        }
            
        default:
            break;
    }
    
    switch (placeType) {
        case PlaceTypeDeparture:
            _searchRequest.origin = iata;
            break;
        case PlaceTypeArrival:
            _searchRequest.destination = iata;
            break;
    }
    
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)dataLoadedSuccessfully {
    [[APIManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self.departureButton];
    }];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType
{
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton:(placeType == PlaceTypeDeparture) ? self.departureButton : self.arrivalButton];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

@end
