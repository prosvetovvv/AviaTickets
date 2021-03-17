//
//  LocationManager.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 17.03.2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationManagerDidUpdateLocation @"kLocationManagerDidUpdateLocation"

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

@property (nonatomic, readonly) CLLocation *currentLocation;

@end

NS_ASSUME_NONNULL_END
