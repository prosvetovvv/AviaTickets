//
//  DataManager.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"
#import "DataSourceType.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

+ (instancetype)sharedInstance;
- (void)loadData;
- (City *)cityForIATA:(NSString *)iata;
- (City *)cityForLocation:(CLLocation *)location;

@end
