Change Log
==========

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
