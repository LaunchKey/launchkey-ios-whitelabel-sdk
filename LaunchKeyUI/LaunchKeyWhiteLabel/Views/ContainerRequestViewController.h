//
//  ContainerRequestViewController.h
//  WhiteLabel
//
//  Created by ani on 4/21/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class ContainerRequestViewController;

@protocol ContainerRequestDelegate <NSObject>

-(void)updateInstructionLabel:(ContainerRequestViewController *)controller updateLabel:(NSString *)labelMessage updateNumber:(int)numberPresented totalNumber:(int)totalNumberOfFactors;
- (void)authorizeRequestFromContainer:(ContainerRequestViewController *) sender withToken:(NSString*)token;
-(void)denyRequestFromContainer:(ContainerRequestViewController *)controller withAuthReason:(AuthResponseReason)reason forAuthMethod:(AuthMethodType)authMethod;
-(void)failRequestFromContainer:(ContainerRequestViewController *)controller withRequest:(NSArray*)authMethods;
@end

@interface ContainerRequestViewController : UIViewController

@property (nonatomic, weak) id <ContainerRequestDelegate> delegateContainer;
@property BOOL isPINEnabled, isCircleCodeEnabled, isBluetoothEnabled, isGeofenceEnabled, isLocationsEnabled, isFingerprintEnabled;
@property(nonatomic, weak) LKCAuthRequestDetails* authRequestDetails;
@property int numberOfFactors;

@end
