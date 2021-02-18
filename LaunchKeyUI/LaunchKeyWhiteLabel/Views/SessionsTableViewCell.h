//
//  SessionsTableViewCell.h
//  Authenticator
//
//  Created by ani on 7/6/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionsTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgApp;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelAppName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelTimeAgo;

@end
