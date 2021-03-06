//
//  TicketsTableViewController.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import <UIKit/UIKit.h>
#import "TicketCell.h"
#import "CoreDataManager.h"
#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "ConstantsLocalization.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsTableViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;

@end

NS_ASSUME_NONNULL_END
