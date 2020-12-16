## Authenticator SDK and Core Authenticator SDK on Carthage

To enable you to use Carthage to add our SDK frameworks to your iOS projects, we have provided a binary project specification for the [Authenticator SDK](https://iovation.github.io/launchkey-ios-authenticator-sdk/Authenticator/Authenticator.json) and the [Core Authenticator SDK](https://iovation.github.io/launchkey-ios-authenticator-sdk/CoreAuthenticator/CoreAuthenticator.json). Please note that we do not provide support for third-party tools such as Carthage; we recommend investigating any issues with the [Carthage user community](https://github.com/Carthage/Carthage/issues).

### Cartfile

`binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/Authenticator/Authenticator.json" == 5.0.0`

`binary "https://iovation.github.io/launchkey-ios-authenticator-sdk/CoreAuthenticator/CoreAuthenticator.json" == 1.0.1`
