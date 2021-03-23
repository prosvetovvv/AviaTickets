//
//  TicketsTableViewController.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 16.03.2021.
//

#import <UIKit/UIKit.h>
#import "TicketCell.h"
#import "CoreDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketsTableViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
