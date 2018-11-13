Change Log
==========
v4.5.0
------
* Fixed
  * Ordering of events so `deviceUnlinked` NSNotification is posted after the keychain is cleared successfully, before generating a new key pair

* Added
  * Support for 3rd Party Push Notification Services by providing `-(void)handlePushPackage:(NSString*)pushPackage` that takes the push package string provided by our LaunchKey API and parses the string to generate the appropriate push notification NSNotification (either `requestReceived` or `deviceUnlinked`)

v4.4.0
------
* Fixed
  * UI Bug related to the UISwitch in the "Verify/Remove Fingerprint" View changing state when the Fingerprint Scan fails
  * Bug in the "Add Circle Code" view on iPad that did not allow certain touch areas for the Circle Code
  * Crash that occurred when attempting to unlink a device in Airplane Mode

* Updated
  * Layout for Add/Remove/Verify Views for Knowledge Factors
  * Layout for the Authorization Slider
  * Messaging

* Added
  * Additional color configurations available in the `-AuthenticatorConfigurator`

v4.3.0
------
* Fixed
  * Bug relating to unlinking the current device by passing the current device object to the `-unlinkDevice` call
  * Authorization Slider UI issue on iPhone X devices

* Updated
  * List of 3rd Party Libraries included in Auth SDK

* Added
  * Support for internal metrics. Implementing apps can call the new `-sendMetrics` method available in the `AuthenticatorManager` to deliver them on demand
  
v4.2.1
------
* Fixed
  * Bug relating to enforced geo-fences
  * Bug relating to policies built "by type" with inherence
  * Circle Code position on iPhone X devices

* Updated
  * Fingerprint/Face Scan Auth Request UI

v4.2.0
------
* Updated
  * Auth SDK to allow for use of concurrent knowledge factors (both PIN Code and Circle Code can be used concurrently)
  * Face ID logo for Face Scan Security Factor

* Added
  * `LocalAuthManager` to allow for Local Auth Requests
	- Implementors can build a `LKPolicy` object either by type (knowledge, inherence, and/or possession), or by count (required number of active factors)
	- Implementors can pass a `LKPolicy` object to `-(void)presentLocalAuth:(UINavigationController*)parentNavController withPolicy:(LKPolicy*)policy withCompletion:(localAuthCompletion)completion;` to bring up a local authenticator request
  * `AuthRequestManager` to (eventually) replace `AuthRequestViewController`
  * Null checks when analyzing Auth Request policies
  * Protection against making changes in the Security View when there is a pending request
  * Better error handling when the map view fails to load in the Add Fence view
  * Support for implementors to let End Users set factors even when unlinked

* Fixed
  * UI issues pertaining to iPhone X devices
  * Issue where a geo-fence could still set up even when Location Services were disabled

* Deprecated
  * The `AuthRequestViewController` class which includes the following methods:
	- `-(id)initWithParentView:(UIViewController*)parentViewController;`
        - `-(void)checkForPendingAuthRequest:(UINavigationController*)parentNavigationController withCompletion:(authRequestCompletion)completion;`

v4.1.1
------
* Fixed
  * Issue pertaining to iPhone X detection
  * UI spacing issue in the Security View
  
v4.1.0
------
* Updated
  * PIN Code View UI with better number/text alignment and larger number font
  * Overall messaging

* Added
  * UI configurations for the subclassed PinCodeButton:
	- `-bulletColor` to allow customization of the color of the bulleted PIN Code (displayed when removing or verifying the PIN Code)
	- `-setBorderColor` and `-setBorderWidth` methods to add and customize a border for the PIN Code buttons
  * Support for Face Scan Security Factor for iPhone X devices, in place of Fingerprint Scan

* Fixed
  * Issue pertaining to jailbreak detection
  * Truncation issues seen in the knowledge factor views on iPhone 5/5c/5s devices
  * Issue pertaining to the use of NSNotifications around Auth Requests
  * Issue pertaining to the geofence check in policies for Auth Requests

v4.0.0
------
* Updated
  * Overall messaging
  * Networking functionality
  * Add Bluetooth Proximity view to only display Bluetooth devices paired with the OS

* Added
  * NSNotification *DeviceKeyPairGenerated* that can be observed to know when the key pair of the device has been generated
  * Two properties to AuthenticatorButton (*negativeActionTextColor* and *negativeActionBackgroundColor*) to set the style of negative actions (unlinking in default devices view, removing a factor, etc.)

* Fixed
  * UI bug that occurs when the activation delay is set to 0 and there is only one active passive factor being removed
  * Issue where the HUD would infinitely spin when an invalid QR code was scanned (i.e. a QR code that represented a linking code less than 7 characters)
  * Issue where the HUD would infinitely spin when there was poor/no internet connectivity
  * Authorization Slider placement on iPads and iPhone 4s devices
  * UI bug when a device is unlinked after 10 failed knowledge factor attempts

* Removed
  * T-OTP’s/Codes
  * `-setEndpoint` method in the AuthenticatorConfigurator to override the API endpoint

v3.0.5
------
* Added
  * Option in the AuthenticatorConfigurator to enable/disable the back bar button item when showing the Security views
  * Option in the AuthenticatorConfigurator to enable/disable the view controller transition animation when showing the Security views
  * IOALabel, which is a subclass of UILabel, that will allow implementers to set the text color of the UILabels in the Security View and Add Proximity Factor View
  * -`lettersColor` to allow implementers to set the text color of the letters in the PIN Code View
  * Miscellaneous optimizations & improvements

* Updated
  * Circle Code color configurations so that the hashmark color picks up on the -`defaultColor` set via the CircleCodeView
  * Settings View to pick up on the background color set for the controls header view

v3.0.4
------
* Added
  * Option in the AuthenticatorConfigurator to set configurable Activation Delay in seconds for passive factors
  * Miscellaneous optimizations & improvements

* Fixed
  * Issue where multiple alert views were shown when checking passive factors
  * Issue where Service-side geo-fences were treated as a device-level factor when checking Auth Requests

v3.0.3
------
* Fixed
  * Issue where service-enforced geo-fence was not being properly checked
  * Issue where Bluetooth proximity and geo-fence factors were not being checked in an auth request after the hour had passed (unless the End User went into the Security View)
  * A TableViewCell width issue in the Default Sessions View
  * A TableView scrolling issue in the Default Devices View

* Updated
  * Passive factor verification time up to 15 seconds before failure
  * Response to “Enter Password” (which is shown after a failed Fingerprint Scan) in the TouchID alert view to bring up the OS-level password screen
  * `-unlinkDevice` logic so that if user is trying to unlink the current device, then the device data is cleared regardless of response from API
  * Callback array in `-getDevices` and `-getSessions` to return an empty array instead of nil if the API returns an error
  * Bluetooth permissions handling in the Add Bluetooth Proximity View

v3.0.2
------
* Fixed
  * Issue where the default endpoint was not being set correctly if `-setEndpoint` was not being called
  * Issue in the `-handleRemoteNotifications` call for push notifications
  * Issue with the UI in the Linking Views for iPhone 5 screen size devices
  * Issue where the device would sporadically crash when linking
  * Issue where denying an auth request would pop the view controller twice
  * Issue where multiple alert views were shown when checking for a geo-fence

* Updated
  * Logic around unlinking a device after 10 failed knowledge factor attempts
  * Miscellaneous error messages
  * Suggested device name shown in the alert view of the Linking Views

* Added
  * Missing strings in the .strings file

v3.0.1
------
* Fixed
  * Issue where `-checkForPendingAuthRequest:withCompletion:` would potentially get stuck in a bad state causing the completion block to never be called

v3.0.0
------
* The White Label SDK is now the Authenticator SDK
  * WhiteLabelConfigurator now AuthenticatorConfigurator
  * WhiteLabelManager now AuthenticatorManager
* Updated and improved UI
* UI now allows for integrators to customize colors via the UIAppearnce proxy and subclassed UI views
* Performance overhaul
* Improving error handling
* Reference docs for more changes between v2.x.x and v3.x.x

v2.3.2
------
* Added
  * LKWApplication object that represents an Application
  * LKWDevice object that represents a Device
  * LKWLogEvent that represents a Log Event (i.e. approving or denying an Auth Request)
  * Added appropriate methods to retrieve newly created objects (i.e. `-getApplications:`, `-getDevices:`, `-getLogEvents:`) which return NSArrays of the objects and deprecated the previous retrieval functions
  * A new method (`-linkUser:withDeviceName:withCompletion:`) to link a user that returns a single block with a NSError object if the call is unsuccessful. Pass *nil* as the device name if you do not wish to use a custom device name. The previous methods to link a user have been deprecated (`-registerUser:withSuccess:withFailure:` and `-registerUser:withDevice:withSuccess:withFailure`)
  * A new method (`-logOutWithViewController:withCompletion:`) to log out of an Application that returns a single block with a NSError object if the call is unsuccessful. The previous method has been deprecated (`-logOut:withSuccess:withFailure:`)
  * A new method (`-unlinkDevice:withController:`) to unlink a device that returns a single block with a NSError object if the call is unsuccessful. The newly created LKWDevice object is passed to the call if a remote device is being unlinked, otherwise *nil* can be passed to unlink the current device
  * A new method (`-checkForPendingAuthRequest:withCompletion:`) to check if there is a pending Auth Request that returns a single block with a NSError object if the call is unsuccessful. The previous method has been deprecated (`-showRequest:withSuccess:withFailure:`)

* Removed
  * The `ExternalAccessory.framework` from the White Label SDK. Integrators no longer need to import this library into their project.

v2.3.1
------
* Added
  * A method (`-handleRemoteNotification`) in the WhiteLabelManager to handle any push notifications received on the device and post the appropriate NSNotification (either *deviceUnlinked* or *requestReceived*)
  * An observer for when a push notification has been received regarding a pending Auth Request (*requestReceived*)

* Fixed
  * Bluetooth issue where if an active Bluetooth device was powered off, the Bluetooth factor check was bypassed when another Bluetooth device was added but not active

v2.3.0
------
* Added
  * “DeviceNotLinkedError” to `-showRequest`
  * An observer (*deviceUnlinked*) for when a device has been unlinked, via call or via API error
  * Method to set the key pair size in the WhiteLabelConfigurator

* Updated
  * Auth request UI and verbiage when more factors were required by the Application
  * Validators for invalid string inputs (Issue #33, Issue #35)
  * PIN Code view so that users can input their PIN Code when the HUD is displayed after an incorrect try (Issue #37)
  * App icon avatar with increased size and removed shadow
  * When registering a new user, the default device name will be based off the system device name, unless the user provides a name (Issue #12)

* Fixed
  * Crash when checking for pending auth requests in Airplane Mode (Issue #34)
  * CFBundle warning in console (Issue #29)
  * Crash when unlinking an already unlinked device (Issue #38)

v2.2.2
------
* Added
  * BOOL sent with NSNotification Object (*activeSessionComplete*)
  * Better error handling for `-unlinkDevice`

* Fixed
  * Issue with combo lock reset button not responding

v2.2.1
------
* Updated
  * `-getSecurityInfo` now returns a NSArray instead of a NSMutableArray

* Added
  * An observer for when `-checkActiveSessions` call has been completed
  * An observer for when an auth request has been hidden after a security factor has been added from the auth request flow

* Fixed
  * Issue with success/failure blocks not being called in `-registerUser withDevice`
  * Issue where `-getSecurityInfo` was returning empty NSDictionaries in the array returned
  * Issue with “context” not being displaying in an auth request

v2.2.0
------
* Updated
  * Logout and UnlinkDevice calls will now remove UI elements if "nil" is passed as the viewController

* Added
  * Constant ints in the DevicesViewController.h to reference for "status" of devices returned
  * More descriptive errors are returned with failure callbacks
  * Method to return which security factors have been set, the type, and whether it is active or not

* Fixed
  * Requirements for importing Foundation and UIKit frameworks to the Bridging Header File in a Swift Project for the SDK to work by adding @class references where needed
  * Intermittent crash when responding to initial auth request after linking (#1)

v2.1.1
------

* Fixed
  * Issue with "Unlinking" HUD not disappearing when unlinkDevice was called
  * Issue with "Secured by LaunchKey" logo being displayed briefly when it should not be

v2.1.0
------

* Fixed
  * Delay with opening up the camera for scanning QR code
* Added
	* Method to set custom font
	* Method to set device name when linking a user
	* Method to override the API endpoint
	* Method to unlink a remote device
	* Method to get the name of the current device
* Removed
	* Requirement for -Obj-C linker flag in the Build Settings
	* Requirement for CoreMedia Framework
	

v2.0.0
------

* Major updates to UI
* WhiteLabelConfigurator updated with new calls for setting colors
* Default UI options for Authorizations, Devices, and Logs
* New Security View and Auth Request View
* Exposed calls for Authorizations, Devices, and Logs

v1.0.3
-----

* Fix issue with linking a White Label user through Dashboard
