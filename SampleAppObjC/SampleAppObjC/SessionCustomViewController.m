//
//  SessionCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "SessionCustomViewController.h"

@interface SessionCustomViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *sessionsArray;
    SessionsViewController *sessionsView;
    NSIndexPath *selectedIndexPath;
}

@end

@implementation SessionCustomViewController

@synthesize tblAuths;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItemEndAll = [[UIBarButtonItem alloc] initWithTitle:@"End All" style:UIBarButtonItemStylePlain target:self action:@selector(endAllSessionsPressed)];
    [rightItemEndAll setAccessibilityIdentifier:@"sessions_end_all"];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItemEndAll, nil]];
    
    self.navigationItem.title =  @"Sessions (Custom UI)";
    
    sessionsView = [[SessionsViewController alloc] initWithParentView:self];

    [LKSessionManager getSessions:^(NSArray* array, NSError *error)
     {
         if(error)
             NSLog(@"Oops error: %@", error);
         else
         {
             sessionsArray = array;
             
             for(IOASession *appObject in sessionsArray)
                 NSLog(@"app name: %@", appObject.serviceName);
             
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
        [self.navigationController popViewControllerAnimated:NO];
    });
}

#pragma mark - TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sessionsArray count];
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
    UIButton *btnRemove = (UIButton*)[cell viewWithTag:6];

    [btnRemove addTarget:self action:@selector(btnRemovePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    IOASession *appObject = [sessionsArray objectAtIndex:indexPath.row];
    NSString *appName = appObject.serviceName;
    
    labelAuthName.text = appName;
    
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
    
    [LKSessionManager endSession:[sessionsArray objectAtIndex:selectedIndexPath.row] completion:nil];
    
    double delayInSeconds = .1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self refreshView];
    });
}

#pragma mark - Refresh View
-(void)refreshView
{
    [LKSessionManager getSessions:^(NSArray* array, NSError *error)
     {
         sessionsArray = array;
         [tblAuths reloadData];
     }];
}

#pragma mark - End All Sessions
-(void)endAllSessionsPressed
{
     [LKSessionManager endAllSessions:^(NSError *error)
     {
         if(error != nil)
         {
             NSLog(@"Error: %@", error);
         }
         else
         {
             [self refreshView];
         }
     }];
}

@end
