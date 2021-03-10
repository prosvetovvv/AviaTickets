//
//  PlaceViewController.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 07.03.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PlaceType.h"

@protocol PlaceViewControllerDelegate <NSObject>
- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;
@end

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;

- (instancetype)initWithType:(PlaceType)type;

@end

