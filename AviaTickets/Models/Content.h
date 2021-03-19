//
//  Content.h
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 19.03.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Content : NSObject

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *title;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
