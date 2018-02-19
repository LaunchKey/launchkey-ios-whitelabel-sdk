//
//  LocalAuthViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 12/8/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import "LocalAuthViewController.h"

@interface LocalAuthViewController ()
{
    NSString *localAuthRequestName;
    int expirationDuration;
}

@end

@implementation LocalAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Test Local Auth";
    
    _tfCountInput.enabled = NO;
    _switchKnowledge.enabled = NO;
    _switchInherence.enabled = NO;
    _switchPossession.enabled = NO;
    localAuthRequestName = @"";
    expirationDuration = 60;
    
    [_switchCount addTarget:self
                         action:@selector(stateChangedCount:) forControlEvents:UIControlEventValueChanged];
    [_switchType addTarget:self
                         action:@selector(stateChangedType:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlinked) name:deviceUnlinked object:nil];
}

-(void)deviceUnlinked
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}

#pragma mark - Switch Methods
- (void)stateChangedCount:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        _switchType.enabled = NO;
        _tfCountInput.enabled = YES;
    }
    else
    {
        _switchType.enabled = YES;
        _tfCountInput.enabled = NO;
    }
}

- (void)stateChangedType:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        _switchCount.enabled = NO;
        _switchKnowledge.enabled = YES;
        _switchInherence.enabled = YES;
        _switchPossession.enabled = YES;
    }
    else
    {
        _switchCount.enabled = YES;
        _switchKnowledge.enabled = NO;
        _switchInherence.enabled = NO;
        _switchPossession.enabled = NO;
    }
}

#pragma mark - Generate Local Auth Pressed
- (IBAction)btnGenerateLocalAuthPressed:(id)sender
{
    localAuthRequestName = _tfLARName.text;
    [[LocalAuthManager sharedManager] setTitle:localAuthRequestName];
    if(_tfExpirationDuration.text != nil)
        [[LocalAuthManager sharedManager] setExpiration:[_tfExpirationDuration.text intValue]];
    else
        [[LocalAuthManager sharedManager] setExpiration:60];
        
    if([_switchCount isOn] || [_switchType isOn])
    {
        LKPolicy *policy = [LKPolicy new];
        
        // Check type of Policy to be built
        if([_switchCount isOn])
        {
            policy = [LKPolicy makeWithCountBuilder:^(LKPolicyByCount *builder){
                builder.countTotal = [_tfCountInput.text intValue];
            }];
        }
        else if([_switchType isOn])
        {
            policy = [LKPolicy makeWithTypeBuilder:^(LKPolicyByType *builder)
                      {
                          builder.knowledge = [_switchKnowledge isOn];
                          builder.inherence = [_switchInherence isOn];
                          builder.possession = [_switchPossession isOn];
                      }];
        }
        
        [self presentLocalAuthWithPolicy:policy];
    }
    else
        [self presentLocalAuthWithPolicy:nil];
}

#pragma mark - Presnet Local Auth
-(void)presentLocalAuthWithPolicy:(LKPolicy *)policy
{
    [[LocalAuthManager sharedManager] presentLocalAuth:self.navigationController withPolicy:policy withCompletion:^(BOOL response, NSError *error)
     {
         [self displayResult:response];
         NSLog(@"local auth error: %@", error);
     }];
}

#pragma mark - Display Result
-(void)displayResult:(BOOL)authenticated
{
     if(authenticated)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Approved"
                                                         message:@"User authenticated"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];

         [alert show];
     }
     else
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied"
                                                         message:@"User denied"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         
         [alert show];
     }
}

@end
