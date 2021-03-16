//
//  TicketCell.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
