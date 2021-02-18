//
//  SessionsViewController.m
//  WhiteLabel
//
//  Created by ani on 5/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "SessionsViewController.h"
#import "SessionsTableViewCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCSession.h>
#import <LKCAuthenticator/LKCAuthenticatorManager.h>
#import "LaunchKeyUIBundle.h"
#import "NSDate+LKTimeAgo.h"

@interface SessionsViewController ()  <UITableViewDataSource, UITableViewDelegate>
{
    UIRefreshControl *refreshControl;
    UILabel *noAuthsLabel;
    UIViewController* __weak _launcherParentViewController;
}

@property (weak, nonatomic) IBOutlet UITableView *tblAuths;
@property (strong, nonatomic) NSMutableArray *authsTableArray;

@end

@implementation SessionsViewController

- (id)initWithParentView:(UIViewController*)parentViewController
{
    _launcherParentViewController = parentViewController;
    
    NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
    
    self = [super initWithNibName:@"SessionsViewController" bundle:bundle];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblAuths addSubview:refreshControl];
    
    noAuthsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _launcherParentViewController.view.center.y - 40, _launcherParentViewController.view.frame.size.width, 20)];
    noAuthsLabel.text = NSLocalizedStringFromTableInBundle(@"lk_authorizations_empty", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [noAuthsLabel setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:20]];
    noAuthsLabel.textAlignment = NSTextAlignmentCenter;
    
    [self loadSessions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Auth
-(void)loadSessions
{
    [[LKCAuthenticatorManager sharedClient] getSessions:^(NSArray<LKCSession*> *array, NSError *error) {
        _authsTableArray = [NSMutableArray arrayWithArray:array];
        self.tblAuths.hidden = NO;
        [self emptyAuthsCheck];
        self.tblAuths.tableHeaderView = nil;
        [self.tblAuths reloadData];
        [refreshControl endRefreshing];
    }];
}

#pragma mark - Empty Auths Check
- (void)emptyAuthsCheck
{
    //Add LaunchKey Logo if Table is empty
    if ([_authsTableArray count] == 0)
    {
        [self.tblAuths addSubview:noAuthsLabel];
    }
    else
    {
        [noAuthsLabel removeFromSuperview];
        self.tblAuths.scrollEnabled = YES;
        self.tblAuths.hidden = NO;
    }
}

#pragma mark - TableView Delegate Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_authsTableArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Log Out" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        LKCSession *session = [_authsTableArray objectAtIndex:indexPath.row];
                                        [self clearSession:session];
                                        [tableView setEditing:NO animated:YES];
                                    }];
    button.backgroundColor = [UIColor redColor];
    
    return @[button];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"SessionCell";
    NSBundle *bundle = [NSBundle LaunchKeyUIBundle];

    [self.tblAuths registerNib:[UINib nibWithNibName:@"SessionsTableViewCell" bundle:bundle] forCellReuseIdentifier:MyIdentifier];
    
    SessionsTableViewCell *cell = (SessionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[SessionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LKCSession *session = [_authsTableArray objectAtIndex:indexPath.row];
    NSString *appName = session.serviceName;
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [cell.labelAppName setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:16.0]];
    cell.labelAppName.text = appName;

    //Set Time Stamp
    NSString *ago = [session.dateCreated timeAgo:nil];
    cell.labelTimeAgo.text = ago;
    
    //Set Image
    NSString *url = session.serviceIcon;
    [cell.imgApp setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:nil success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
     }];
    
    //Makes image Circle
    cell.imgApp.layer.cornerRadius = cell.imgApp.frame.size.width / 2;
    cell.imgApp.clipsToBounds = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
        [cell.labelTimeAgo setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:14]];
    
    [self emptyAuthsCheck];
    
    return cell;
}

#pragma mark - End All Sessions
-(void)endAllSessions:(completion)completion
{
    [[LKCAuthenticatorManager sharedClient] endAllSessions:completion];
}

#pragma mark - Clear Sessions
-(void)clearSession:(LKCSession *)application
{
    [[LKCAuthenticatorManager sharedClient] endSession:application completion:^(NSError *error) {
        [self loadSessions];
    }];
}

#pragma mark - Refresh Control
-(void)handleRefresh:(id)sender
{
    [self loadSessions];
}

-(void)refreshSessionsView
{
    [self loadSessions];
}

@end
