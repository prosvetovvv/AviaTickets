//
//  APIManager.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import <Foundation/Foundation.h>
#import "SearchRequest.h"
#import "DataManager.h"
#import "City.h"
#import "Ticket.h"


NS_ASSUME_NONNULL_BEGIN

@class City;

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)downloadPhotoFrom:(NSString *)urlString to:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_END
