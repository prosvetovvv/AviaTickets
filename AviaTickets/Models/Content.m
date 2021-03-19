//
//  Content.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 19.03.2021.
//

#import "Content.h"

@implementation Content

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        _image = image;
        _title = title;
    }
    return self;
}

@end
