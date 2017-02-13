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

@interface AuthenticatorConfigurator : NSObject

+(AuthenticatorConfigurator*)sharedConfig;

-(void)setEndpoint:(NSString*)endpoint;
-(NSString*)getEndpoint;

-(void)setKeyPairSize:(int)keyPairSize;
-(int)getKeyPairSize;

-(void)setFont:(NSString*)customFont;
-(NSString*)getFont;

-(UIColor*)lighterColorForColor:(UIColor*)c;
-(UIColor*)darkerColorForColor:(UIColor*)c;

-(void)turnOnSSLPinning;
-(void)turnOffSSLPinning;
-(BOOL)shouldEnforcePinning;

-(void)enableInfo:(BOOL)enable;
-(BOOL)shouldEnableInfo;

-(void)enableHeaderViews:(BOOL)enable;
-(BOOL)shouldEnableHeaderViews;

-(void)enableSecurityFactorImages:(BOOL)enable;
-(BOOL)shouldEnableSecurityFactorImages;

-(void)setControlsBackgroundColor:(UIColor*)color;
-(UIColor*)getControlsBackgroundColor;

-(void)enableNotificationPrompt:(BOOL)enable;
-(BOOL)shouldEnableNotificationPrompt;

@end
