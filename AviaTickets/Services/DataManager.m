//
//  DataManager.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 06.03.2021.
//

#import "DataManager.h"

@interface DataManager()
@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;
@end

@implementation DataManager

+ (instancetype)sharedInstance
{
    static DataManager *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    
    return instance;
}

- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self->_countriesArray = [self createObjectsFromArray:countriesJsonArray withType:DataSourceTypeCountry];
        
#ifndef NDEBUG
        NSLog(@"%lu", (unsigned long)self->_countriesArray.count);
        NSLog(@"%@", self->_countriesArray.description);
#endif
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self->_citiesArray = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self->_airportsArray = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
        });
        NSLog(@"Completed load data");
    });
}


- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}


- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type
{
    NSMutableArray *results = [NSMutableArray new];
    
    for (NSDictionary *jsonObject in array) {
        switch (type) {
            case DataSourceTypeCountry:
            {
                Country *country = [[Country alloc] initWithDictionary:jsonObject];
                [results addObject:country];
                break;
            }
            case DataSourceTypeCity:
            {
                City *city = [[City alloc] initWithDictionary:jsonObject];
                [results addObject:city];
                break;
            }
            case DataSourceTypeAirport:
            {
                Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
                [results addObject:airport];
                break;
            }
        }
    }
    
    
//    for (NSDictionary *jsonObject in array) {
//        if (type == DataSourceTypeCountry) {
//            Country *country = [[Country alloc] initWithDictionary:jsonObject];
//            [results addObject:country];
//        }
//        else if (type == DataSourceTypeCity) {
//            City *city = [[City alloc] initWithDictionary:jsonObject];
//            [results addObject:city];
//        }
//        else if (type == DataSourceTypeAirport) {
//            Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
//            [results addObject:airport];
//        }
//    }
    
    return results;
}

- (NSArray *)countries
{
    return _countriesArray;
}

- (NSArray *)cities
{
    return _citiesArray;
}

- (NSArray *)airports
{
    return _airportsArray;
}

@end
