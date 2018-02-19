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

static const int activationDelayMin = 0;
static const int activationDelayDefault = 600;
static const int activationDelayMax = 86400;

@interface AuthenticatorConfigurator : NSObject

+(AuthenticatorConfigurator*)sharedConfig;

-(NSString*)getEndpoint;

-(void)setKeyPairSize:(int)keyPairSize;
-(int)getKeyPairSize;

-(void)setActivationDelayProximity:(int)time;
-(int)getActivationDelayProximity;
-(void)setActivationDelayGeofence:(int)time;
-(int)getActivationDelayGeofence;

-(void)setFont:(NSString*)customFont;
-(NSString*)getFont;

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

-(void)enableViewControllerTransitionAnimation:(BOOL)enable;
-(BOOL)shouldEnableViewControllerAnimation;

-(void)enableBackBarButtonItem:(BOOL)enable;
-(BOOL)shouldEnableBackBarButtonItem;

-(void)enableSecurityChangesWhenUnlinked:(BOOL)enable;
-(BOOL)shouldEnableSecurityChangesWhenUnlinked;

@end
