//
//  ATPlaceCell.m
//  AviaTickets
//
//  Created by Vitaly Prosvetov on 09.03.2021.
//

#import "ATPlaceCell.h"

#define HeightCell  44.0
#define WeightCell [UIScreen mainScreen].bounds.size.width
#define WeightImageView 44.0
#define HeightImageView  44.0
#define Padding 5.0

@interface ATPlaceCell ()

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, copy) UILabel *nameLabel;
@property (nonatomic, copy) UILabel *codeLabel;
@property (nonatomic, assign) PlaceType placeType;

@end

@implementation ATPlaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeType:(PlaceType)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _placeType = type;
        
        [self setupNameLabel];
        [self setupCodeLabel];
        [self setupImageView];
    }
    return self;
}

#pragma mark - Public

- (void)setWith:(NSString *)name and:(NSString *)code
{
    _nameLabel.text = name;
    _codeLabel.text = code;
}

#pragma mark - Setup UI

- (void)setupNameLabel
{
    CGRect frame = CGRectMake(Padding, 0.0, WeightCell - WeightImageView, HeightCell * 2 / 3);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_nameLabel];
}

- (void)setupCodeLabel
{
    CGRect frame = CGRectMake(Padding, HeightCell * 2 / 3, WeightCell - WeightImageView, HeightCell / 3);
    _codeLabel = [[UILabel alloc] initWithFrame:frame];
    _codeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_codeLabel];
}

- (void)setupImageView
{
    CGRect frame = CGRectMake(WeightCell - WeightImageView, self.contentView.center.y, WeightImageView, HeightImageView);
    self.image = [[UIImageView alloc] initWithFrame:frame];
    //self.image = [[UIImageView alloc] initWithFrame:self.bounds];
    self.image.image = [UIImage systemImageNamed:@"airplane"];
    self.image.tintColor = [UIColor redColor];
    self.image.contentMode = UIViewContentModeScaleAspectFit;
    
    switch (self.placeType) {
        case PlaceTypeDeparture:
            self.image.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
            break;
        case PlaceTypeArrival:
            self.image.transform = CGAffineTransformMakeRotation(M_PI_2 / 3);
            break;
    }
    
    [self.contentView addSubview:self.image];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //self.image.frame = CGRectMake(WeightCell - WeightImageView, self.contentView.center.y, WeightImageView, HeightImageView);
}

@end
