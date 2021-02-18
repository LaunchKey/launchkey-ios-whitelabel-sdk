//
//  CircleCodeWidgetControl.h
//  LaunchKey
//
//  Created by ani on 1/3/16.
//  Copyright © 2016 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCombinationProtocol.h"

@interface CircleCodeWidgetControl : UIControl

@property (weak) id <LKCombinationProtocol> delegate;

@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;
@property (nonatomic, strong) UIImageView *hash;
@property BOOL createCombo;
@property (nonatomic,assign) int angle;

-(id)initWithFrame:(CGRect)frame andDelegate:(id)del;

@end
