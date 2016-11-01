//
//  AuthorizationCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "AuthorizationCustomViewController.h"

@interface AuthorizationCustomViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *authsArray;
    AuthorizationViewController *authsView;
    NSIndexPath *selectedIndexPath;
}

@end

@implementation AuthorizationCustomViewController

@synthesize tblAuths;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation Bar Buttons
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    leftItem.tintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryTextAndIconsColor];
    [[self navigationItem] setLeftBarButtonItem:leftItem];
    
    //Navigation Bar Title
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = @"Authorizations (Custom UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    authsView = [[AuthorizationViewController alloc] initWithParentView:self];
    
    [authsView getApplications:^(NSArray* array, NSError *error)
     {
         if(error)
             NSLog(@"Oops error: %@", error.localizedRecoverySuggestion);
         else
         {
             authsArray = array;
             
             for(LKWApplication *appObject in authsArray)
                 NSLog(@"app name: %@", appObject.name);
             
             [tblAuths reloadData];
         }
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlinked) name:deviceUnlinked object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deviceUnlinked object:nil];
}

-(void)deviceUnlinked
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - Menu Methods
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [authsArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"AuthCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    //Set Cell Tags
    UILabel *labelAuthName = (UILabel*)[cell viewWithTag:1];
    UILabel *labelContext = (UILabel*)[cell viewWithTag:2];
    UILabel *labelAction = (UILabel*)[cell viewWithTag:3];
    UILabel *labelStatus = (UILabel*)[cell viewWithTag:4];
    UILabel *labelTransactional = (UILabel*)[cell viewWithTag:5];
    UIButton *btnRemove = (UIButton*)[cell viewWithTag:6];
    
    [btnRemove addTarget:self action:@selector(btnRemovePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    LKWApplication *appObject = [authsArray objectAtIndex:indexPath.row];
    NSString *appName = appObject.name;
    NSString *context = appObject.context;
    NSString *action = appObject.action;
    NSString *status = appObject.status;
    NSString *transactional = appObject.session;
    
    labelAction.text = action;
    labelStatus.text = status;
    
    if([transactional isEqualToString:@"0"])
        labelTransactional.hidden = NO;
    else
        labelTransactional.hidden = YES;
    
    labelAuthName.text = appName;
    labelContext.text = context;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(NSIndexPath *) getButtonIndexPath:(UIButton *) button
{
    CGRect buttonFrame = [button convertRect:button.bounds toView:tblAuths];
    return [tblAuths indexPathForRowAtPoint:buttonFrame.origin];
}

#pragma mark - Buttons Methods
-(void)btnRemovePressed:(id)sender
{
    NSIndexPath *indexPath = [self getButtonIndexPath:sender];
    selectedIndexPath = indexPath;
    
    [authsView clearApplication:[authsArray objectAtIndex:selectedIndexPath.row]];
    
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [authsView getApplications:^(NSArray* array, NSError *error)
         {
             authsArray = array;
             
             [tblAuths reloadData];
         }];
    });
}


@end