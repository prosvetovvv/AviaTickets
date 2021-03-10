//
//  ViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "SearchRequest.h"

@interface MainViewController ()

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    
    [self setupSelf];
    [self setupDepartureButton];
    [self setupArrivalButton];
}

#pragma mark - Setup UI

- (void)setupSelf
{
    self.title = @"Search";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void) setupDepartureButton
{
    self.departureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.departureButton.frame = CGRectMake(30.0, 140.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    self.departureButton.layer.cornerRadius = 10;
    self.departureButton.clipsToBounds = YES;
    self.departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.departureButton.tintColor = [UIColor blackColor];
    [self.departureButton setTitle:@"Departure" forState: UIControlStateNormal];
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.departureButton];
}

- (void) setupArrivalButton
{
    self.arrivalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.arrivalButton.frame = CGRectMake(30.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    self.arrivalButton.layer.cornerRadius = 10;
    self.arrivalButton.clipsToBounds = YES;
    self.arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    self.arrivalButton.tintColor = [UIColor blackColor];
    [self.arrivalButton setTitle:@"Arrival" forState: UIControlStateNormal];
    [self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.arrivalButton];
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

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType
{
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton:(placeType == PlaceTypeDeparture) ? self.departureButton : self.arrivalButton];
}

@end
