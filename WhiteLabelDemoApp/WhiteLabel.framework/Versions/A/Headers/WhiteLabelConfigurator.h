//
//  WhiteLabelConfigurator.h
//  WhiteLabel
//
//  Created by Kristin Tomasik on 3/16/15.
//  Copyright (c) 2015 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

static const int keypair_minimum = 2048;
static const int keypair_medium = 3072;
static const int keypair_maximum = 4096;

@interface WhiteLabelConfigurator : NSObject

+(WhiteLabelConfigurator*)sharedConfig;

-(void)setEndpoint:(NSString*)endpoint;
-(NSString*)getEndpoint;

-(void)setKeyPairSize:(int)keyPairSize;
-(int)getKeyPairSize;

-(void)setFont:(NSString*)customFont;
-(NSString*)getFont;

-(void)setPrimaryColor:(UIColor*)primaryColor;
-(void)setSecondaryColor:(UIColor*)secondaryColor;
-(void)setPrimaryTextAndIcons:(UIColor*)primaryTextAndIcons;
-(void)setBackgroundColor:(UIColor*)backgroundColor;

-(UIColor*)getPrimaryColor;
-(UIColor*)getSecondaryColor;
-(UIColor*)getPrimaryTextAndIconsColor;
-(UIColor*)getBackgroundColor;
-(UIColor*)getPrimaryDarkColor;
-(UIColor*)getAccentLightColor;

-(UIColor*)lighterColorForColor:(UIColor*)c;
-(UIColor*)darkerColorForColor:(UIColor*)c;

-(void)turnOnSSLPinning;
-(void)turnOffSSLPinning;
-(BOOL)shouldEnforcePinning;

@end
