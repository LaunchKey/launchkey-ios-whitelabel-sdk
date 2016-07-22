//
//  DevicesViewController.h
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completion)(NSMutableArray* array, NSError *error);

static const int statusLinking = 0;
static const int statusLinked = 1;
static const int statusUnlinking = 2;

@interface DevicesViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getDeviceList:(Completion)block;

-(void)refreshDevicesView;

-(NSString*)getCurrentDevice;

@end
