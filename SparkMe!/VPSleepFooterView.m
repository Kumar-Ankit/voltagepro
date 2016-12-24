//
//  VPSleepTimingCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/24/16.
//
//

#import "VPSleepFooterView.h"
#import "Utility.h"
#define kLableFont REGULAR(10.0)
@interface VPSleepFooterView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation VPSleepFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{

    UIView *bg = [[UIView alloc] initWithFrame:CGRectZero];
    bg.backgroundColor = [UIColor clearColor];
    self.backgroundView = bg;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = kLableFont;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    self.btnEdit = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnEdit setImage:[UIImage imageNamed:@"icon_edit_time"] forState:UIControlStateNormal];
    [self.btnEdit setTintColor:kDarkBlueGrayColor];
    [self.contentView addSubview:self.btnEdit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect rect = self.contentView.bounds;
    float x,y,sPadding,aWidth;
    CGSize tSize;
    
    sPadding = kDefaultSidePadding;
    
    //imgaeView
    tSize = CGSizeMake(kDefaultCellImageHeight, kDefaultCellImageHeight);
    x = rect.size.width - sPadding - kDefaultCellImageHeight;
    y = CenteredOrigin(rect.size.height, tSize.height);
    self.btnEdit.frame = (CGRect){x,y,tSize};
    
    // text
    aWidth = rect.size.width - kDefaultCellImageHeight - 3 * sPadding;
    tSize = [Utility sizeForString:self.titleLabel.text font:self.titleLabel.font width:aWidth];
    x = sPadding;
    y = CenteredOrigin(rect.size.height, tSize.height);
    self.titleLabel.frame = (CGRect){x,y,tSize};
}

- (void)setFrom:(NSString *)from to:(NSString *)to{
    self.titleLabel.text = [NSString stringWithFormat:@"Enabling Sleep will disable notifications from %@ to %@",from,to];
    [self setNeedsLayout];
}

+ (CGFloat)heightForWidth:(float)width
{
    float sPadding,aWidth;
    CGSize tSize;
    CGFloat h = 0.0;
    
    h += 8.0;
    sPadding = kDefaultSidePadding;
    aWidth = width - kDefaultCellImageHeight - 3 * sPadding;
    tSize = [Utility sizeForString:@"Enabling Sleep will disable notifications from 10:00 PM to 7:00 AM"
                              font:kLableFont width:aWidth];
    h += tSize.height;
    h += 8.0;
    return h;
}

@end
