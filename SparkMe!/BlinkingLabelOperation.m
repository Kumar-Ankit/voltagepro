//
//  BlinkingLabelOperation.m

#import "BlinkingLabelOperation.h"
#import "BlinkingColors.h"

@interface BlinkingLabelOperation ()
- (void)updateLabel;
@end

@implementation BlinkingLabelOperation

- (id)init {
    self =nil;
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class BlinkingLabelOperation"
                                 userInfo:nil];
    return nil;
}

// default initializer
- (id)initWithLabel:(UILabel *)label freq:(NSTimeInterval)interval normalColors:(BlinkingColors *)normal blinkColors:(BlinkingColors *)blink {
    self = [super init];
    if (self) {
        mode_ = YES;
        interval_ = interval;
        normalColors_ = normal;
        blinkColors_ = blink;
        
        // Dont retain the label, because if the view unloads
        // the operation stop
        label_ = label;
    }
    return self;
}

- (id)initWithLabel:(UILabel *)label freq:(NSTimeInterval)interval blinkColors:(BlinkingColors *)blink {
    // get the current color of label as the normal color
    BlinkingColors *normal = [[BlinkingColors alloc] initWithBackgroundColor:label.backgroundColor
                                                                   textColor:label.textColor];
    // call the designated initializer
    return [self initWithLabel:label freq:interval
                  normalColors:normal blinkColors:blink];
}

- (void)main {
    SEL update = @selector(updateLabel);
    [self setThreadPriority:0.0];
    
    while (![self isCancelled]) {
        if (label_ == nil)
            break;
        
        [NSThread sleepForTimeInterval:interval_];
        [self performSelectorOnMainThread:update withObject:nil waitUntilDone:YES];
    }
}

- (void)updateLabel {
    BlinkingColors *currentColors = nil;
    
    if (mode_)
        currentColors = blinkColors_;
    else
        currentColors = normalColors_;
    
    [label_ setTextColor:currentColors.textColor];
    [label_ setBackgroundColor:currentColors.backgroundColor];

    mode_ = !mode_;
}

- (void)dealloc {
    blinkColors_ =nil;
    normalColors_ =nil;
    // don't release the label because I never owned it
    
}

@end

