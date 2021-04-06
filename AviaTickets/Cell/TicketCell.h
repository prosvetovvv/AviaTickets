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
#import "ConstantsLocalization.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) MapTicket *mapTicket;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
