//
//  ExpirationTimerView.h
//  Authenticator
//
//  Created by ani on 11/13/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpirationTimerView : UIView

@property (nonatomic, assign) int expirationDuration;
@property (nonatomic, assign) BOOL isBigTimer;
@property (nonatomic, assign) NSString *expiresAt;
-(void)invalidateTimer;

@end
