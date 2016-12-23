//
//  TwoButtonViewCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "TwoButtonViewCell.h"
#import "Utility.h"

@interface TwoButtonViewCell ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *separator;

@end

@implementation TwoButtonViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier saveSel:(SEL)saveSel delSel:(SEL)delSel target:(id)target
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [self.saveButton setTintColor:kGreenColor];
        [self.saveButton.titleLabel setFont:kCellButtonFont];
        [self.saveButton setBackgroundColor:kButtonSaveColor];
        [self.saveButton addTarget:target action:saveSel forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_saveButton];
        
        if (delSel) {
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
            [self.cancelButton setTintColor:kAppSelectionRedColor];
            [self.cancelButton.titleLabel setFont:kAppNormalButtonFont];
            [self.cancelButton addTarget:target action:delSel forControlEvents:UIControlEventTouchUpInside];
            [self.cancelButton setBackgroundColor:kButtonCancleColor];
            [self.contentView addSubview:_cancelButton];
        }
        
        self.separator = [[UIView alloc] initWithFrame:CGRectZero];
        self.separator.backgroundColor = kTableViewCellSeparatorColor;
        [self.contentView addSubview:_separator];
    }
    return self;
}

- (void)updateLeftTitle:(NSString *)lefTitle rightTitle:(NSString *)rightTitle{
    [self.saveButton setTitle:[rightTitle uppercaseString] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[lefTitle uppercaseString] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    float width = size.width;
    float x = 0.0;
    if (_cancelButton) {
        width = size.width/2.0;
        x = width;
        self.cancelButton.frame = (CGRect) {0.0, 0.0, width, size.height};
    }
    
    self.saveButton.frame = (CGRect) {x, 0.0, width, size.height};
    
    float sepWidth = 1.0/[UIScreen mainScreen].scale;
    self.separator.frame = (CGRect) {size.width/2.0, 0.0, sepWidth, size.height};
}


@end
