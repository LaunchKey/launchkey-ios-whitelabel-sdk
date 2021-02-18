//
//  GeofenceWidgetViewController.h
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class GeofenceWidgetViewController;

@protocol GeofenceWidgetDelegate <NSObject>

-(void)geofenceVerified:(GeofenceWidgetViewController *)controller geofenceVerified:(BOOL)geofenceValid withAuthResponseReason:(AuthResponseReason)reason;
-(void)fencesVerified:(GeofenceWidgetViewController *)controller fenceVerified:(BOOL)verified withAuthResponseReason:(AuthResponseReason)reason;
@end

@interface GeofenceWidgetViewController : UIViewController

@property (nonatomic,weak) id <GeofenceWidgetDelegate> delegate;
@property (weak, nonatomic) LKCAuthRequestDetails* authRequestDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imgBorder;
@property (weak, nonatomic) IBOutlet UIImageView *imageFactor;

@end
