//  LocationsWidgetViewController.h
//  Authenticator
//
//  Created by ani on 4/2/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class LocationsWidgetViewController;

@protocol LocationsWidgetDelegate <NSObject>

-(void)locationsVerified:(LocationsWidgetViewController*)controller locationVerified:(BOOL)locationValid withAuthResponseReason:(AuthResponseReason)reason;

@end

@interface LocationsWidgetViewController : UIViewController

@property (nonatomic,weak) id <LocationsWidgetDelegate> delegate;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imgBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imageFactor;

@end

