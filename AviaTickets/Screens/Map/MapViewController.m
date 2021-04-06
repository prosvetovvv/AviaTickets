//
//  MapViewController.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 17.03.2021.
//

#import "MapViewController.h"

#define AnnotationIdentifier @"AnnotationIdentifier"

@interface MapViewController ()  <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationManager;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = TitleMapViewController;
    
    [self setupMapView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationManagerDidUpdateLocation object:nil];

    [[DataManager sharedInstance] loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void) setupMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

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

- (void)setPrices:(NSArray *)prices {
    
    _prices = prices;
    [self.mapView removeAnnotations: self.mapView.annotations];
    
    for (MapPrice *price in prices) {
        Ticket *ticket = [[Ticket alloc] initWithMapPrice:price];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld %@.", (long)price.value, Currency];
            annotation.coordinate = price.destination.coordinate;
            annotation.ticket = ticket;
            
            [self.mapView addAnnotation: annotation];
        });
    }
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (annotationView) {
        annotationView.annotation = annotation;
    } else {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0.0, 5.0);
        annotationView.rightCalloutAccessoryView = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"plus"] target:nil action:nil];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPointAnnotation *selectedAnnotation = (MKPointAnnotation *)view.annotation;
    
    [[CoreDataManager sharedInstance] addToSelectedFromMap:selectedAnnotation.ticket];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AlertTitleMapViewController
                                                                             message:AlertMessageMapViewController
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
