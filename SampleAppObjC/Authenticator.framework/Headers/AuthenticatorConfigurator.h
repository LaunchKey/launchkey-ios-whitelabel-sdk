//
//  WhiteLabelConfigurator.h
//  WhiteLabel
//
//  Created by Kristin Tomasik on 3/16/15.
//  Copyright (c) 2015 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@interface AuthenticatorConfigurator : NSObject

+(AuthenticatorConfigurator*)sharedConfig;

-(NSString*)getEndpoint;

-(void)setKeyPairSize:(int)keyPairSize __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(int)getKeyPairSize __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setActivationDelayProximity:(int)time __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(int)getActivationDelayProximity __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(void)setActivationDelayGeofence:(int)time __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(int)getActivationDelayGeofence __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setFont:(NSString*)customFont __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(NSString*)getFont __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)turnOnSSLPinning __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(void)turnOffSSLPinning __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnforcePinning __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableInfo:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableInfo __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableHeaderViews:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableHeaderViews __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableSecurityFactorImages:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableSecurityFactorImages __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setControlsBackgroundColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getControlsBackgroundColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableNotificationPrompt:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableNotificationPrompt __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableViewControllerTransitionAnimation:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableViewControllerAnimation __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableBackBarButtonItem:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableBackBarButtonItem __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)enableSecurityChangesWhenUnlinked:(BOOL)enable __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(BOOL)shouldEnableSecurityChangesWhenUnlinked __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setTableViewHeaderBackgroundColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getTableViewHeaderBackgroundColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setTableViewHeaderTextColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getTableViewHeaderTextColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setSecurityViewsTextColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getSecurityViewsTextColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setGeofenceCircleColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getGeofenceCircleColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

-(void)setSecurityFactorImageTintColor:(UIColor*)color __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));
-(UIColor*)getSecurityFactorImageTintColor __attribute((deprecated("Please build an AuthenticatorConfig object and initalize the SDK with the AuthenticatorManager instead")));

@end
