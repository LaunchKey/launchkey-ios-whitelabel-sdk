# Multifactor Authentication Mobile Authenticator SDK for iOS

* [Overview](#overview)
* [Usage](#usage)
* [Links](#links)
* [Support](#support)

# <a name="overview"></a>Overview

Multifactor Authentication is an identity and access management platform. The Authenticator SDK for iOS enables developers to quickly integrate
the Multifactor Authentication platform directly in their existing iOS applications.

Developer documentation for using the Core Authenticator SDK is found [here](https://docs.launchkey.com/authenticator-sdk/core/integrate-core-authenticator-sdk.html).

Developer documentation for using the Authenticator SDK is found [here](https://docs.launchkey.com/authenticator-sdk/ui/integrate-authenticator-sdk.html).

# <a name="usage"></a>Usage

This project uses [Carthage](https://github.com/Carthage/Carthage) to manage dependencies.
Clone this repo and in the root of project run "carthage update --use-xcframeworks"
Open Whitelabel.xcworkspace to get started.

If you wish to build for simulators within the workspace, there is a temporary workaround. Add "arm64" to the "Excluded Architectures" build setting for the LaunchKeyUI target Authenticator.

Do not use launchkey-ios-authenticator-sdk.xcodeproj maunally, this project is only here to enable us to support carthage distribution.

To configure the sample apps to work with your LaunchKey backend service you need to update the SDK key in the AppDelegate as well as the 'LKEndpoint' field in the corresponding info.plist.

#  <a name="links"></a>Links

Check our [documentation](https://docs.launchkey.com/authenticator-sdk/before-you-begin.html) for setting up
a Multifactor Authentication Service.

#  <a name="support"></a>Support

## FAQ's

Browse FAQ's or submit a question to the Multifactor Authentication support team for both
technical and non-technical issues. Visit the Multifactor Authentication Support website [here](https://www.iovation.com/contact).
