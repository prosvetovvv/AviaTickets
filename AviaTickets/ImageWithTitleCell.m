//
//  ImageWithTitleCell.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 19.03.2021.
//

#import "ImageWithTitleCell.h"

@interface ImageWithTitleCell ()

@end

@implementation ImageWithTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = UIListContentTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    _imageView.frame = self.contentView.frame;
    _titleLabel.frame = CGRectMake(0.0, CGRectGetMaxX(self.contentView.frame) - 25.0, self.contentView.frame.size.width, 20.0);
}

@end
