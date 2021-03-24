//
//  FavoriteTicket+CoreDataProperties.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 23.03.2021.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic flightNumber;
@dynamic price;
@dynamic to;
@dynamic from;
@dynamic airline;
@dynamic returnDate;
@dynamic expires;
@dynamic departure;
@dynamic created;

@end
