//
//  LocationManager.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 17.03.2021.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation LocationManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _manager = [CLLocationManager new];
        _manager.delegate = self;
        
        [_manager requestWhenInUseAuthorization];
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    
    if (locations) {
        _currentLocation = location;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationManagerDidUpdateLocation object:location];
    }
}


- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    
    switch (manager.authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.manager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self.manager startUpdatingLocation];
        case kCLAuthorizationStatusDenied: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to determine the geolocation" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [[[UIApplication sharedApplication].windows firstObject].rootViewController presentViewController:alert animated:YES completion:nil];
            break;
        }
            
            
        default: {
           
            
            break;
        }
            
    }
}

@end
