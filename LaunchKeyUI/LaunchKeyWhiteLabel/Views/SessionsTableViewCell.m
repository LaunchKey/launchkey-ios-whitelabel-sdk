//
//  SessionsTableViewCell.m
//  Authenticator
//
//  Created by ani on 7/6/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#define screenwidth [[UIScreen mainScreen]bounds].size.width

#import "SessionsTableViewCell.h"

@implementation SessionsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = screenwidth;
    
    [super setFrame:frame];
}

@end
