//
//  LogsViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completion)(NSMutableArray* array, NSError *error);

@interface LogsViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getLogs:(Completion)block;

-(void)refreshLogsView;

@end