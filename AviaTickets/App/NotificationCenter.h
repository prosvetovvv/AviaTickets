//
//  NotificationCenter.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 26.03.2021.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

typedef struct Notification {
    __unsafe_unretained NSString * _Nullable title;
    __unsafe_unretained NSString * _Nonnull body;
    __unsafe_unretained NSDate * _Nonnull date;
    __unsafe_unretained NSURL * _Nullable imageURL;
} Notification;


NS_ASSUME_NONNULL_BEGIN

@interface NotificationCenter : NSObject

+ (instancetype)sharedInstance;

- (void)registerService;
- (void)sendNotification:(Notification)notification;

- (Notification) makeNotification:(NSString *)title body:(NSString *)body date:(NSDate *)date imageURL:(NSURL *)imageURL;

@end

NS_ASSUME_NONNULL_END
