//
//  NotificationCenter.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 26.03.2021.
//

#import "NotificationCenter.h"


#define ImageIdentifier @"imageIdentifier"
#define NotificationIdentifier @"notificationIdentifier"

@interface NotificationCenter () <UNUserNotificationCenterDelegate>

@end

@implementation NotificationCenter

+ (instancetype)sharedInstance {
    static NotificationCenter *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken ,^{
        instance = [NotificationCenter new];
    });
    return instance;
}

- (void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Request authorization succeeded");
        }
    }];
}

- (void) sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    if (notification.imageURL) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:ImageIdentifier URL:notification.imageURL options:nil error:nil];
        
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    NSDateComponents *newComponents = [NSDateComponents new];
    
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NotificationIdentifier content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center addNotificationRequest:request withCompletionHandler:nil];
}

- (Notification)makeNotification:(NSString *)title body:(NSString *)body date:(NSDate *)date imageURL:(NSURL *)imageURL {
    Notification notification;
    
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageURL = imageURL;
    
    return notification;
}

@end
