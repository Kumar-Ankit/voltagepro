//
//  AttributeViewController.h
//  Sparky
//
//  Created by Hung on 24/08/12.
//
//

#import <UIKit/UIKit.h>
#import "ILTranslucentView.h"

@interface AttributeViewController : UIViewController{
    ILTranslucentView *blurView;
}

@property (strong, nonatomic) IBOutlet ILTranslucentView *blurView;

- (IBAction)done:(id)sender;

@end
