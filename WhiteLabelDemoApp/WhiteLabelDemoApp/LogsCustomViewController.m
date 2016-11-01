//
//  LogsCustomViewController.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/11/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "LogsCustomViewController.h"

@interface LogsCustomViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    LogsViewController *logsView;
    NSArray *logsArray;
}

@end

@implementation LogsCustomViewController

@synthesize tblLogs;

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
    lbNavTitle.text = @"Logs (Custom UI)";
    lbNavTitle.textColor = [UIColor whiteColor];
    [lbNavTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    self.navigationItem.titleView = lbNavTitle;
    self.navigationController.navigationBar.barTintColor = [[WhiteLabelConfigurator sharedConfig] getPrimaryColor];
    
    logsView = [[LogsViewController alloc] initWithParentView:self];
    
    [logsView getLogEvents:^(NSArray* array, NSError *error)
     {
         if(error)
             NSLog(@"Oops error: %@", error.localizedRecoverySuggestion);
         else
         {
             logsArray = array;
             for(LKWLogEvent *logObject in logsArray)
             {
                 NSLog(@"app name: %@", logObject.appName);
             }
             
             [tblLogs reloadData];
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
    return [logsArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"LogCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    //Set Cell Tags
    UILabel *labelLogName = (UILabel*)[cell viewWithTag:1];
    UILabel *labelContext = (UILabel*)[cell viewWithTag:2];
    UILabel *labelState = (UILabel*)[cell viewWithTag:3];
    UILabel *labelDateAndTime = (UILabel*)[cell viewWithTag:4];
    UILabel *labelDevice = (UILabel*)[cell viewWithTag:5];
    
    LKWLogEvent *logObject = [logsArray objectAtIndex:indexPath.row];
    
    NSString *logName = logObject.appName;
    NSString *context = logObject.context;
    NSString *status = [logObject.status lowercaseString];
    NSString *action = [logObject.action lowercaseString];
    NSString *session = logObject.session;
    NSString *device = logObject.deviceName;
    NSString *state;
    
    labelLogName.text = logName;
    
    // Date and Time
    NSString *dateFromServer = logObject.dateUpdated;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateServer = [dateFormatter dateFromString:dateFromServer];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd yyyy hh:mm:ss a"];
    NSString *convertedString = [dateFormatter stringFromDate:dateServer];
    
    labelDateAndTime.text = [NSString stringWithFormat:@"Date & Time: %@", convertedString];
    
    if([device isEqualToString:@""] || device == nil)
        labelDevice.hidden = YES;
    else
    {
        labelDevice.hidden = NO;
        labelDevice.text = [NSString stringWithFormat:@"Device: %@",device];
    }
    if([context isEqualToString:@""] || context == nil)
        labelContext.hidden = YES;
    else
    {
        labelContext.hidden = NO;
        NSString *updatedContext = [[context componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        labelContext.text = [NSString stringWithFormat:@"Context: %@", updatedContext];
    }
    
    state = @"ERROR";
    
    // Set Status
    if([action isEqualToString:@"authenticate"])
    {
        if([status isEqualToString:@"denied"])
            state = @"DENIED";
        else if([status isEqualToString:@"granted"])
        {
            if([session isEqualToString:@"0"])
                state = @"APPROVED";
            else
                state = @"APPROVED";
        }
        else
            state = @"PENDING";
    }
    else if ([action isEqualToString:@"revoke"])
    {
        if([status isEqualToString:@"granted"])
            state = @"LOGGED OUT";
        else
            state = @"CLEARED";
    }
    
    labelState.text = state;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

@end
