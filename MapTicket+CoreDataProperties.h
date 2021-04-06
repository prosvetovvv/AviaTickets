//
//  MapTicket+CoreDataProperties.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 24.03.2021.
//
//

#import "MapTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapTicket (CoreDataProperties)

+ (NSFetchRequest<MapTicket *> *)fetchRequest;

@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *departureDate;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
