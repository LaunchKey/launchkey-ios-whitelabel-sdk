//
//  DevicesTableViewCell.m
//  WhiteLabel
//
//  Created by ani on 5/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#define screenwidth [[UIScreen mainScreen]bounds].size.width

#import "DevicesTableViewCell.h"

@implementation DevicesTableViewCell

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
