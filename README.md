# ios-sdk

## SDK to integrate with Silt's signup
This is an SDK to integrate with an iOS app Silt's KYC & ID verification.
The Silt's SDK Framework is inside the SiltSDK directory.
More information concerning API and other SDKs is available at https://getsilt.com/developers

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

### 1. Add a button that calls the `loadSiltSignup` func
  ```
  // siltButtonBlue position and target
  siltButtonBlue.addTarget(self, action: #selector(loadSiltSignup), for: .touchUpInside)
  siltButtonBlue.setStyle(bStyle: "blue")
  siltButtonBlue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  ```
    
### 2. The `loadSiltSignup` func. Check the `SiltSDKExamples/ViewController.swift` for an example.
    
  Ask for your `companyAppId` on customers@getsilt.com or get it from https://dashboard.getsilt.com
  and use it in the initializer.
    
  #### tldr;
  Example of all code for function `loadSiltSignup` for verifying users for KYC:
  ```
  @objc func loadSiltSignup() {
      let vc = SiltWebviewController(companyAppId:"{{YOUR_COMPANY_APP_ID}}", extraQuery:"&user_email=test@getsilt.com")

      // Subscribe to the notification that will be triggered when a user finishes Silt's verification flow,
      // that will run "onFinishedSiltVerification" function
      NotificationCenter.default.addObserver(self, selector: #selector(onFinishedSiltVerification(_:)), name: .didFinishedSiltVerification, object: nil)

      // set the Presentation style of the webview
      vc.modalPresentationStyle = .overFullScreen //or .overFullScreen for transparency
      self.present(vc, animated: true, completion: nil)
  }
  ```
  ----
  Detailed explanation for `loadSiltSignup` function.

  Ask for your `companyAppId` on customers@getsilt.com or get it from https://dashboard.getsilt.com
  and use it in the initializer as:
  ```
  SiltWebviewController(companyAppId: {YOUR_CUSTOMER_APP_ID} )
  ```
  Demo companyAppId: `2022a022-a662-4c58-8865-a1fb904d2cde`.

  Add the argument `"outTransition: .fromLeft"` to SiltWebviewController to define an out animation when closing the webview

  Example KYC:
  ```
  @objc func loadSiltSignup() {
      let vc = SiltWebviewController(companyAppId:"2022a022-a662-4c58-8865-a1fb904d2cde", extraQuery:"&user_email=test@getsilt.com")
      ...
  ```

  Example Biocheck:
  ```
  @objc func loadSiltSignup() {
      let vc = SiltWebviewController(companyAppId:"2022a022-a662-4c58-8865-a1fb904d2cde",
                                     path: "biocheck",
                                     extraQuery:"&temp_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxx")
      ...
  ```
  Subscribe to the notification that will be triggered when a user finishes Silt's verification flow,
  that will run `onFinishedSiltVerification` function
  ```
  NotificationCenter.default.addObserver(self, selector: #selector(onFinishedSiltVerification(_:)), name: .didFinishedSiltVerification, object: nil)
  ```
  You can also subscribe to the notifications `didGotSiltUserID` after getting a userID, and `didGotCompanyAppToken` after getting an app token.
  `siltUserId` or `siltCompanyAppToken` values will be inside the userInfo object.
  ```
  NotificationCenter.default.addObserver(self, selector: #selector(onGotSiltUserId(_:)), name: .didGotSiltUserID, object: nil)
  NotificationCenter.default.addObserver(self, selector: #selector(onGotCompanyAppToken(_:)), name: .didGotCompanyAppToken, object: nil)
  ```
  You can create a transition with the `getTransition` func provided by Silt
  ```
  view.window!.layer.add(getTransition(subtype: .fromRight), forKey: kCATransition)
  ```

  Set the Presentation style of the webview
  ```
      vc.modalPresentationStyle = .overFullScreen //or .overFullScreen for transparency
      self.present(vc, animated: true, completion: nil)
  ```  
  You can also set default animation
  ```
  self.present(vc, animated: true, completion: nil)
  ```
### 3. The `onFinishedSiltVerification` func that recovers the silt Id. Check the `SiltSDKExamples/ViewController.swift` for an example
  ```
  @objc func onFinishedSiltVerification(_ notification: Notification) {
          let siltUserId = notification.userInfo?["siltUserId"] as? String
          let siltCompanyAppToken = notification.userInfo?["siltCompanyAppToken"] as? String
          if(!(siltUserId!).isEmpty && !(siltCompanyAppToken!).isEmpty){
              // Call your backend here to verify this userId
              print("Got a verified user Id: \(siltUserId!) \(siltCompanyAppToken!)")
          }
      }
   ```
### 4. Implement a call from your backend to Silt's backend to retrieve the user verification status and information. Check more on this in https://getsilt.com/developers


## How it works
This SDK consists only in a button that opens a webview and captures once the user has finished the verification in the webview a user ID.
This is the user ID you can use to verify the ID verification of that user in Silt.
