//
//  MapTicket+CoreDataProperties.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 24.03.2021.
//
//

#import "MapTicket+CoreDataProperties.h"

@implementation MapTicket (CoreDataProperties)

+ (NSFetchRequest<MapTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MapTicket"];
}

@dynamic price;
@dynamic from;
@dynamic to;
@dynamic airline;
@dynamic departureDate;
@dynamic created;

@end
