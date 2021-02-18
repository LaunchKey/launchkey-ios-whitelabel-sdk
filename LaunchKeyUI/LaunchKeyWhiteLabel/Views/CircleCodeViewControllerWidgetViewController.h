//
//  CircleCodeViewControllerWidgetViewController.h
//  LaunchKey
//
//  Created by ani on 1/2/16.
//  Copyright © 2016 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCodeWidgetControl.h"
#import "LKUIStringVerification.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class CircleCodeViewControllerWidgetViewController;

@protocol CircleCodeViewControllerDelegate <NSObject>

-(void)updateLabel:(CircleCodeViewControllerWidgetViewController *)controller updateString:(NSString *)labelMessage;

-(void)CircleCodeVerified:(CircleCodeViewControllerWidgetViewController *)controller CircleCodeIsVerfied:(BOOL)validCircleCode;

@end

@interface CircleCodeViewControllerWidgetViewController : UIViewController

@property AuthMethodWidgetState state;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (weak, nonatomic) IBOutlet UILabel *labelWarning;
@property (nonatomic, weak) id <CircleCodeViewControllerDelegate> delegate;
@property BOOL verifyAlways;
@property (strong, nonatomic) CircleCodeWidgetControl *combo;
@end
