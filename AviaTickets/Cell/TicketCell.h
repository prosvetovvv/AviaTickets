//
//  TicketCell.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "APIManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "MapTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) MapTicket *mapTicket;

@end

NS_ASSUME_NONNULL_END
