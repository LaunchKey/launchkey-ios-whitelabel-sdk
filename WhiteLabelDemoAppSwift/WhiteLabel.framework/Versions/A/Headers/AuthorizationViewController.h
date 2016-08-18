//
//  AuthorizationViewController.h
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completion)(NSMutableArray* array, NSError *error);

@interface AuthorizationViewController : UIViewController

-(id)initWithParentView:(UIViewController*)parentViewController;

-(void)getAuthorizations:(Completion)block;

-(void)refreshAuthsView;

-(void)setNoAuthsLabelTextColor:(UIColor*)color;

-(void)hideNoAuthsLabel:(BOOL)hide;

-(void)clearAuthorization:(NSInteger)cellIndex;

@end
