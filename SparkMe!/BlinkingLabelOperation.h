//
//  BlinkingLabelOperation.h

#import <Foundation/Foundation.h>

@class BlinkingColors;

@interface BlinkingLabelOperation : NSOperation {
@private
    BOOL mode_;
    UILabel *label_;
    NSTimeInterval interval_;
    
    BlinkingColors *blinkColors_;
    BlinkingColors *normalColors_;
}

- (id)init;
- (id)initWithLabel:(UILabel *)label freq:(NSTimeInterval)interval blinkColors:(BlinkingColors *)blink;
- (id)initWithLabel:(UILabel *)label freq:(NSTimeInterval)interval 
       normalColors:(BlinkingColors *)normal blinkColors:(BlinkingColors *)blink;

@end