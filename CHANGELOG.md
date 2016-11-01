Change Log
==========

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
