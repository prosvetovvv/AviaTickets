//
//  MKPointAnnotation+Ticket.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 25.03.2021.
//

#import "MKPointAnnotation+Ticket.h"


@implementation MKPointAnnotation (Ticket)

NSString const *key = @"my.very.unique.key";

@dynamic ticket;

- (Ticket *)ticket {
    return objc_getAssociatedObject(self, &key);
}

- (void)setTicket:(Ticket *)ticket {
    objc_setAssociatedObject(self, &key, ticket, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
