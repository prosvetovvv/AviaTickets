//
//  ATPlaceCell.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 09.03.2021.
//

#import <UIKit/UIKit.h>
#import "PlaceType.h"


@interface ATPlaceCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeType:(PlaceType)type;
- (void)setWith:(NSString *)name and:(NSString *)code;

@end

