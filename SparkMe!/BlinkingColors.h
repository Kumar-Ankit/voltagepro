//
//  BlinkingColors.h

#import <Foundation/Foundation.h>

@interface BlinkingColors : NSObject {
@private 
    UIColor *back_;
    UIColor *text_;
}

@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *textColor;

- (id)init;
- (id)initWithBackgroundColor:(UIColor *)back textColor:(UIColor *)text;

@end