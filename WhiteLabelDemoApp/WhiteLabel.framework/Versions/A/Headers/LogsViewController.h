//
//  LogsViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKWLogEvent.h"

typedef void (^Completion)(NSArray *array, NSError *error);
typedef void (^getLogEventsCompletion)(NSArray<LKWLogEvent*> *array, NSError *error);

@interface LogsViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getLogs:(Completion)block __attribute((deprecated("Use -getLogEvents:")));

-(void)getLogEvents:(getLogEventsCompletion)block;

-(void)refreshLogsView;

@end