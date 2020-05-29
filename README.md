# ios-sdk

## SDK to integrate with Silt's signup
This is an SDK to integrate with an iOS app Silt's KYC & ID verification.
The Silt's SDK Framework is inside the SiltSDK directory.

## How to

The only code you will need to add to your app is in the example ViewController file:
SiltSDKExamples/ViewController.swift

- Simply create a pod file or add the line `pod 'SiltSDK', '~> 1.0'`.

```
target 'MyApp' do
  pod 'SiltSDK', '~> 1.0'
end
```

- Run the command `$ pod install`.
- Open `YourApp.xcworkspacep` and build.

The SiltSDK is a cocoapod available at:
https://cocoapods.org/pods/SiltSDK

Here is a guide to get started with cocoapods: https://guides.cocoapods.org/using/getting-started.html
And a guide to import a cocoapod library to your app: https://guides.cocoapods.org/using/using-cocoapods.html


## How it works
This SDK consists only in a button that opens a webview and captures once the user has finished the verification in the webview a user ID.
This is the user ID you can use to verify the ID verification of that user in Silt.
