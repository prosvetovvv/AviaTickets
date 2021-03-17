//
//  MapViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 17.03.2021.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Map prices";
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationManagerDidUpdateLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)dataLoadedSuccessfully {
    self.locationManager = [[LocationManager alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [self.mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        self.origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (self.origin) {
            
            [[APIManager sharedInstance] mapPricesFor:self.origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

//- (void)setPrices:(NSArray *)prices {
//    self.prices = prices;
//    [self.mapView removeAnnotations: self.mapView.annotations];
// 
//    for (MapPrice *price in prices) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
//            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
//            annotation.coordinate = price.destination.coordinate;
//            [self.mapView addAnnotation: annotation];
//        });
//    }
//}

@end
