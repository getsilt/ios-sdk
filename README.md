# ios-sdk

## SDK to integrate with Silt's signup
This is an SDK to integrate with an iOS app Silt's KYC & ID verification.
The Silt's SDK Framework is inside the SiltSDK directory.

## How to import the SDK

- Simply create a pod file named `Podfile` or add the line `pod 'SiltSDK', '~> 1.2'`.
```
target 'MyApp' do
  pod 'SiltSDK', '~> 1.2'
end
```
(More info on Podfile here: (https://guides.cocoapods.org/using/the-podfile.html))
 
- Run the command `$ pod install`.
- IMPORTANT: Open `YourApp.xcworkspacep` and build.
- To finish, add `Privacy - Camera Usage Description`: `Camera usage description` to your `Info.plist` file.

The SiltSDK is a cocoapod available at:
https://cocoapods.org/pods/SiltSDK

Here is a guide to get started with cocoapods: https://guides.cocoapods.org/using/getting-started.html
And a guide to import a cocoapod library to your app: https://guides.cocoapods.org/using/using-cocoapods.html

## How to use it
The only code you will need to add to your app is in the example ViewController file:
`SiltSDKExamples/ViewController.swift`
You will need:
- A button that calls the `loadSiltSignup` func
- The `loadSiltSignup` func. Check the `SiltSDKExamples/ViewController.swift` for an example
- The `onVerifiedUserId` func that recovers the silt Id. Check the `SiltSDKExamples/ViewController.swift` for an example
- Implement a call from your backend to Silt's backend to retrieve the user verification status and information

## How it works
This SDK consists only in a button that opens a webview and captures once the user has finished the verification in the webview a user ID.
This is the user ID you can use to verify the ID verification of that user in Silt.
