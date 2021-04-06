//
//  MKPointAnnotation+Ticket.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 25.03.2021.
//

#import <MapKit/MapKit.h>
#import <objc/runtime.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPointAnnotation (Ticket)

@property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
