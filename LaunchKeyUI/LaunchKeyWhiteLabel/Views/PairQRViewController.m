//
//  PairQRViewController.m
//  WhiteLabel
//
//  Created by ani on 4/12/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "PairQRViewController.h"
#import "LKUIConstants.h"
#import <AVFoundation/AVFoundation.h>
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import <LKCAuthenticator/LKCAuthenticatorManager.h>
#import "LaunchKeyUIBundle.h"
#import "LKUIStringVerification.h"

@interface PairQRViewController () <UIGestureRecognizerDelegate>
{
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    NSString *_qrEntry, *QRContents, *defaultDeviceName, *labelWarning, *_sdkKey;
    BOOL inCameraMode, noCameraAccess, noCamera, _stopped;
    UIBarButtonItem *rightItem, *rightInfo;
}

@property (strong, nonatomic) NSString *deviceName;

@end

@implementation PairQRViewController

@synthesize btnTapToFinish;
@synthesize viewQR, viewManualEntry;
@synthesize tfQREntry;
@synthesize inCameraMode;

-(void)displayLinkingViewWithCamera:(BOOL)camera withSDKKey:(NSString*)sdkKey
{
    if(camera)
        inCameraMode = YES;
    else
        inCameraMode = NO;
    
    _sdkKey = sdkKey;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnTapToFinishPressed:)];
    gesture.cancelsTouchesInView = NO;
    [btnTapToFinish addGestureRecognizer:gesture];
    
    if(inCameraMode)
        self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Linking_View_Title_Scan", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else
        self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Linking_View_Title_Enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(inCameraMode)
         rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_View_Title_Enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) style:UIBarButtonItemStylePlain target:self action:@selector(switchPressed:)];
    else
        rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_View_Title_Scan", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) style:UIBarButtonItemStylePlain target:self action:@selector(switchPressed:)];
    
    UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
    rightInfo = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];

    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem, rightInfo, nil]];
    else
        self.navigationItem.rightBarButtonItem = rightItem;
    
    [self underlineTextFieldToGrey:tfQREntry];
    tfQREntry.placeholder = @"A B C D 1 2 3";
    if([IOATextField appearance].placeholderTextColor == nil)
    {
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:tfQREntry.attributedPlaceholder];
        [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(199.0/255.0) green:(199.0/255.0) blue:(205.0/255.0) alpha:1.0] range:NSMakeRange(0, [placeholderAttributedString length])];
        tfQREntry.attributedPlaceholder = placeholderAttributedString;
    }
    else
    {
        NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:tfQREntry.attributedPlaceholder];
        [placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[IOATextField appearance].placeholderTextColor range:NSMakeRange(0, [placeholderAttributedString length])];
        tfQREntry.attributedPlaceholder = placeholderAttributedString;
    }

    defaultDeviceName = [UIDevice currentDevice].name;
    _deviceName = defaultDeviceName;
    
    btnTapToFinish.titleLabel.numberOfLines = 1;
    btnTapToFinish.titleLabel.adjustsFontSizeToFitWidth = YES;
    btnTapToFinish.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    if(inCameraMode)
    {
        [self dismissKeyboard];
        
        viewManualEntry.hidden = YES;
        tfQREntry.hidden = YES;
        tfQREntry.enabled = NO;
        viewQR.hidden = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetQrReader];
        });
    }
    else
    {
        viewManualEntry.hidden = NO;
        viewQR.hidden = YES;
        tfQREntry.hidden = NO;
        tfQREntry.enabled = YES;
        [tfQREntry becomeFirstResponder];
    }
    
    btnTapToFinish.enabled = NO;
    btnTapToFinish.hidden = YES;
}

-(void)underlineTextFieldToGrey:(UITextField*)textField
{
    CALayer *bottomBorder = [CALayer layer];
    CGFloat borderWidth = 1.5f;
    bottomBorder.borderColor = [UIColor colorWithRed:(214.0/255.0) green:(214.0/255.0) blue:(214.0/255.0) alpha:1.0].CGColor;
    bottomBorder.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    bottomBorder.borderWidth = borderWidth;
    [textField.layer addSublayer:bottomBorder];
    textField.layer.masksToBounds = YES;
}

-(void)underlineTextFieldToBlack:(UITextField*)textField
{
    CALayer *bottomBorder = [CALayer layer];
    CGFloat borderWidth = 1.5f;
    bottomBorder.borderColor = [UIColor blackColor].CGColor;
    bottomBorder.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    bottomBorder.borderWidth = borderWidth;
    [textField.layer addSublayer:bottomBorder];
    textField.layer.masksToBounds = YES;
}

-(void)noCameraAccess
{
    // Permission has been denied.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Error_Camera_Permission", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"AV_QR_Scanner_Privacy_Declined", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    });
}

#pragma mark - TextField Methods
-(void)resetManualEntryFields
{
    _qrEntry = @"";
    tfQREntry.text = @"";
    [self underlineTextFieldToGrey:tfQREntry];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    for (int i = 0; i < [string length]; i++)
    {
        unichar c = [string characterAtIndex:i];
        if (![myCharSet characterIsMember:c])
        {
            textField.text = [_qrEntry uppercaseString];
            return NO;
        }
    }
    
    if(textField.text.length > 7)
    {
        textField.text = [_qrEntry uppercaseString];
        return NO;
    }
    else
    {
        _qrEntry = textField.text;
    }
    
    if (_qrEntry.length == 7)
    {
        btnTapToFinish.enabled = YES;
        btnTapToFinish.hidden = NO;
        textField.text = [_qrEntry uppercaseString];
    }
    else
    {
        btnTapToFinish.enabled = NO;
        btnTapToFinish.hidden = YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(_qrEntry.length == 7)
    {
        [self presentDeviceNameAlert];
        return YES;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
        });
        
        return NO;
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - QR Scanner
-(void)resetQrReader
{
    _stopped = false;
    noCameraAccess = NO;
    noCamera = NO;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied)
    {
        // denied
        [self noCameraAccess];
        noCameraAccess = YES;
    }
    else if(authStatus == AVAuthorizationStatusRestricted)
    {
        // restricted, normally won't happen
        [self noCameraAccess];
        noCameraAccess = YES;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        // not determined?!
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
            
             if(granted)
             {
                 // Access has been granted ..do something
                 [self resetQrReader];
             }
             else
             {
                 // Access denied ..do something
                 
                     [self noCameraAccess];
                     noCameraAccess = YES;
                 
             }
         }];
    }
    else {
        // Camera permission granted access
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpCamera];
            [_captureSession startRunning];
        });
    }
}

-(BOOL)setUpCamera
{
    NSError *error;

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if (!input)
    {
        return NO;
    }

    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];

    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];

    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("QRCodeQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];

    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:viewQR.layer.bounds];
    [viewQR.layer addSublayer:_videoPreviewLayer];

    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            NSString *result=[metadataObj stringValue];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopReading:result];
            });
        }
    }
}

-(void)stopReading:(NSString*)contents
{
    if (_stopped)
        return;
    
    _stopped = true;
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    
    QRContents = contents;
    
    [self presentDeviceNameAlert];
}

#pragma mark - Parse Code
-(void)postQrCode:(NSString*)contents fromScanner:(BOOL)qrScanner {
    dispatch_async(dispatch_get_main_queue(), ^{

        UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil
               message:NSLocalizedStringFromTableInBundle(@"Linking_HUD", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
        preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:toast animated:YES completion:nil];
        
        BOOL isDevieNameValid = [LKUIStringVerification isDeviceNameValid:_deviceName];

        if(!isDevieNameValid)
        {
            _deviceName = [LKUIStringVerification cleanUpDeviceName:_deviceName];
        }
                
        [[LKCAuthenticatorManager sharedClient] linkDevice:contents withSDKKey:_sdkKey withDeviceName:_deviceName deviceNameOverride:true withCompletion:^(NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [toast dismissViewControllerAnimated:YES completion:nil];
            });
            
            if(error != nil)
            {
                if(!inCameraMode)
                    [tfQREntry becomeFirstResponder];
                
                if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Scan_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                {
                    if(inCameraMode)
                        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_QR_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Scan_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                    else
                        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                }
                else if([error.localizedDescription isEqualToString:NSLocalizedStringFromTableInBundle(@"Error_Internet_Connection_Appears_Offline", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Error_No_Connection_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Error_No_Connection_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                else if([error.localizedFailureReason isEqualToString:@"Asynchronous request for authentication has been cancelled."])
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"SSL_Pinning_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                else
                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Linking_Code_Invalid_Error_Message", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tfQREntry resignFirstResponder];
                    // Add a delay before posting notifications that trigger AuthenticatorManager.m completion block
                    double delayInSeconds = 0.4;
                    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLKLaunchKeyDevicePaired object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLKLaunchKeyCloseQRView object:nil];
                    });
                });
            }
        }];
    });
}

#pragma mark - Button Methods
- (IBAction)btnTapToFinishPressed:(id)sender
{
    [self presentDeviceNameAlert];
}

-(void)helpPressed:(id)sender
{
    NSString *helpAlertString;
    
    if(inCameraMode)
        helpAlertString = NSLocalizedStringFromTableInBundle(@"lk_wl_link_info_scanqrcode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else
        helpAlertString = NSLocalizedStringFromTableInBundle(@"lk_wl_link_info_entercode", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Help", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:helpAlertString];
}

-(void)presentDeviceNameAlert
{
    [self.view endEditing:YES];
    
    if(inCameraMode)
    {
        _stopped = true;
        [_captureSession stopRunning];
        _captureSession = nil;
        
        [_videoPreviewLayer removeFromSuperlayer];
    }
 
    UIAlertController *alertDeviceName = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Linking_Set_Device_Name", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Cancel", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action)
                                {
                                    if(inCameraMode)
                                    {
                                        double delayInSeconds = .3;
                                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                            [self resetQrReader];
                                        });
                                    }
                                }];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                            {
                                UITextField *tfDeviceName = alertDeviceName.textFields[0];
                                
                                if (tfDeviceName.text.length < 1|| [LKUIStringVerification stringContainsEmoji:tfDeviceName.text] || [LKUIStringVerification isInValidEntry:tfDeviceName.text])
                                {
                                    if ([LKUIStringVerification stringContainsEmoji:tfDeviceName.text])
                                        labelWarning = [NSString stringWithFormat:@"%@", NSLocalizedStringFromTableInBundle(@"Warning_No_Emoji", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                    else if ([LKUIStringVerification isInValidEntry:tfDeviceName.text])
                                        labelWarning = [NSString stringWithFormat:@"%@", NSLocalizedStringFromTableInBundle(@"Warning_Illegal_Characters", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                    else
                                        labelWarning = [NSString stringWithFormat:@"%@", NSLocalizedStringFromTableInBundle(@"Warning_One_Character", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
                                    
                                    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:labelWarning];
                                    
                                    _deviceName = @"";
                                }
                                else
                                {
                                    // Device Name OK
                                    
                                    NSString *trimmedString = [[NSString stringWithString:tfDeviceName.text] stringByTrimmingCharactersInSet:
                                                               [NSCharacterSet whitespaceCharacterSet]];
                                    _deviceName = trimmedString;
                                    
                                    [tfDeviceName resignFirstResponder];
                                    
                                    if(!inCameraMode)
                                    {
                                        if (_qrEntry.length == 7)
                                            [self postQrCode:[_qrEntry lowercaseString] fromScanner:NO];
                                    }
                                    else
                                        [self postQrCode:QRContents fromScanner:YES];
                                }
                            }];
    
    [alertDeviceName addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = defaultDeviceName;
         [textField becomeFirstResponder];
         textField.keyboardType = UIKeyboardTypeDefault;
     }];
    
    [alertDeviceName addAction:cancelBtn];
    [alertDeviceName addAction:okBtn];
    [self presentViewController:alertDeviceName animated:YES completion:nil];
}

- (void)switchPressed:(id)sender
{
    if(!inCameraMode)
    {
        [self dismissKeyboard];
        
        inCameraMode = YES;

        self.navigationItem.title = @"Scan Code";
    
        rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Enter Code" style:UIBarButtonItemStylePlain target:self action:@selector(switchPressed:)];
        UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [rightHelpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
        rightInfo = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];
        if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem, rightInfo, nil]];
        else
            self.navigationItem.rightBarButtonItem = rightItem;
        
        viewManualEntry.hidden = YES;
        tfQREntry.hidden = YES;
        tfQREntry.enabled = NO;
        btnTapToFinish.hidden = YES;
        btnTapToFinish.enabled = NO;
        viewQR.hidden = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetQrReader];
        });
    }
    else
    {
        inCameraMode = NO;
        
        self.navigationItem.title = @"Enter Code";
        
        rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan Code" style:UIBarButtonItemStylePlain target:self action:@selector(switchPressed:)];
        UIButton *rightHelpButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [rightHelpButton addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
        rightInfo = [[UIBarButtonItem alloc] initWithCustomView:rightHelpButton];
        if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem, rightInfo, nil]];
        else
            self.navigationItem.rightBarButtonItem = rightItem;
        
        viewManualEntry.hidden = NO;
        tfQREntry.hidden = NO;
        tfQREntry.enabled = YES;
        btnTapToFinish.hidden = YES;
        btnTapToFinish.enabled = NO;
        viewQR.hidden = YES;
        viewManualEntry.hidden = NO;
        [tfQREntry becomeFirstResponder];
        
        [self resetManualEntryFields];
        
        _stopped = true;
        [_captureSession stopRunning];
        _captureSession = nil;
    }
}

#pragma mark - Show Alert View
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                                    if(inCameraMode && !noCameraAccess && !noCamera)
                                    {
                                       double delayInSeconds = .3;
                                       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                       dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                           [self resetQrReader];
                                       });
                                   }
                               }];
    
    [alert addAction:okButton];
    
    // Ensure alert is displayed in main thread
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
