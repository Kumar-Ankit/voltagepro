//
//  BlinkingColors.m

#import "BlinkingColors.h"

@implementation BlinkingColors

@synthesize backgroundColor = back_;
@synthesize textColor = text_;

- (id)init {
    self=nil;
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class BlinkingColors"
                                 userInfo:nil];
    return nil;
}

- (id)initWithBackgroundColor:(UIColor *)back textColor:(UIColor *)text {
    self = [super init];
    if (self) {
        back_ = back;
        text_ = text;
    }
    return self;
}

- (void)dealloc {
    back_ =nil;
    text_ =nil;

}

@end