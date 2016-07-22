//
//  ContainerViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
{
    AuthRequestViewController *authRequestChildView;
}

@end

@implementation ContainerViewController

@synthesize containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    authRequestChildView = [[AuthRequestViewController alloc] initWithParentView:self];
    
    [self addChildViewController:authRequestChildView];
    [self.containerView addSubview:authRequestChildView.view];
    [authRequestChildView didMoveToParentViewController:self];
    
    //Navigation Bar Buttons
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    UIBarButtonItem *rightItemRefresh = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavRefresh"] style:UIBarButtonItemStyleDone target:self action:@selector(btnRefreshPressedNav:)];
    
    leftItem.tintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryTextAndIconsColor];;
    rightItemRefresh.tintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryTextAndIconsColor];;

    [[self navigationItem] setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItemRefresh, nil]];

    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = @"Auth Request View";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    [authRequestChildView showRequest:self withSucess:^{
        
    } withFailure:^(NSString *errorMessage, NSString *errorCode){
        
        NSLog(@"%@, %@", errorMessage, errorCode);
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestApproved) name:requestApproved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDenied) name:requestDenied object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oldRequest) name:possibleOldRequest object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)requestApproved
{
    // This will be called when an auth request has been approved... Add any custom UI here
}

-(void)requestDenied
{
    // This will be called when an auth request has been denied... Add any custom UI here
}

-(void)oldRequest
{
    // This will be called when the user responds to a possible old request... Add any custom UI here
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnRefreshPressedNav:(id)sender
{
    [authRequestChildView showRequest:self withSucess:^{
        
    } withFailure:^(NSString *errorMessage, NSString *errorCode){
        
        NSLog(@"%@, %@", errorMessage, errorCode);
        
    }];
}

@end