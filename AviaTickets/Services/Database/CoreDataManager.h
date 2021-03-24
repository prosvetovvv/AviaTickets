//
//  CoreDataManager.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "MapTicket+CoreDataClass.h"
#import "DataManager.h"
#import "Ticket.h"
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray <FavoriteTicket *> *)favorites;

- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

- (void)addToSelectedFromMap:(Ticket *)ticket;
- (void)removeFromSelectedFromMap:(Ticket *)ticket;
- (NSArray <MapTicket *> *)mapTickets;

@end

NS_ASSUME_NONNULL_END
