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

New for Core SDK 1.0.1 and UI SDK 5.0.0, you can install our Core Auth SDK or our UI Auth SDK via Carthage using a Cartfile that looks like:

```ogdl
binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/CoreAuthenticator/CoreAuthenticator.json" == 1.0.1
binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/Authenticator/Authenticator.json" == 5.0.0
```

The Core Auth SDK requires 3rd party dependencies: AFNetworking, Base64, and FraudForce SDK.

The UI Auth SDK requires all Core Auth SDK dependencies. To grab everything required using carthage, your Cartfile should look like:

```ogdl
github "AFNetworking/AFNetworking" == 4.0.1
github "soheilbm/Base64" "67083ec1e3e970ec920cbf126e6957c6e9e88ae4"
binary "https://iovation.github.io/deviceprint-SDK-iOS/FraudForce.json" == 5.0.3
binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/CoreAuthenticator/CoreAuthenticator.json" == 1.0.1
binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/Authenticator/Authenticator.json" == 5.0.0
```

This project uses [Carthage](https://github.com/Carthage/Carthage) to manage dependencies.
To explore the UI Auth SDK source and use our demo apps, clone this repo and in the root of project run "carthage update --use-xcframeworks"
Open Whitelabel.xcworkspace to get started.

If you wish to build for devices within the workspace, there is a temporary workaround. Remove "arm64" from the "Excluded Architectures" build setting for the LaunchKeyUI target Authenticator.

To configure the sample apps to work with your LaunchKey backend service you need to update the SDK key in the AppDelegate as well as the 'LKEndpoint' field in the corresponding info.plist.

#  <a name="links"></a>Links

Check our [documentation](https://docs.launchkey.com/authenticator-sdk/before-you-begin.html) for setting up
a Multifactor Authentication Service.

#  <a name="support"></a>Support

## FAQ's

Browse FAQ's or submit a question to the Multifactor Authentication support team for both
technical and non-technical issues. Visit the Multifactor Authentication Support website [here](https://www.iovation.com/contact).
