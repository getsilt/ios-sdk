//
//  ViewController.swift
//  silt-sdk-storyboard
//
//  Created by Marc on 21/04/2020.
//  Copyright © 2020 Silt. All rights reserved.
//

import UIKit
import WebKit
import SiltSDK

class ViewController: UIViewController, UIWebViewDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var siltButtonBlue: SiltButton!
    @IBOutlet weak var siltButtonSilver: SiltButton!
    @IBOutlet weak var anyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // siltButtonBlue position and target
        siltButtonBlue.addTarget(self, action: #selector(loadSiltSignup), for: .touchUpInside)
        siltButtonBlue.setStyle(bStyle: "blue")
        siltButtonBlue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // siltButtonBlue position and target
        siltButtonSilver.addTarget(self, action: #selector(loadSiltSignup), for: .touchUpInside)
        siltButtonSilver.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // siltButtonBlue position and target
        anyButton.addTarget(self, action: #selector(loadSiltSignup), for: .touchUpInside)
        anyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func loadSiltSignup() {
        // Ask for your companyAppId on customers@getsilt.com
        // and use it in the initializer as SiltWebviewController(companyAppId: {YOUR_CUSTOMER_APP_ID} )
        // demo companyAppId: 2022a022-a662-4c58-8865-a1fb904d2cde
        // add the argument "outTransition: .fromLeft" to SiltWebviewController to define an out animation when closing the webview
        
        let vc = SiltWebviewController(companyAppId:"2022a022-a662-4c58-8865-a1fb904d2cde", extraQuery:"&user_email=test@getsilt.com")
        // let vc = SiltWebviewController(companyAppId:"2022a022-a662-4c58-8865-a1fb904d2cde", path: "biocheck", extraQuery:"&temp_token=ab7f9678-671b-4640-a540-cd1fadc90b15")
        // Subscribe to the notification that will be triggered when a user finishes Silt's verification flow,
        // that will run "onFinishedSiltVerification" function
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishedSiltVerification(_:)), name: .didFinishedSiltVerification, object: nil)
        
        // You can also subscribe to the notifications 'didGotSiltUserID' after getting a userID, and 'didGotCompanyAppToken' after getting an app token.
        // 'siltUserId' or 'siltCompanyAppToken' values will be inside the userInfo object.
        // NotificationCenter.default.addObserver(self, selector: #selector(onGotSiltUserId(_:)), name: .didGotSiltUserID, object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(onGotCompanyAppToken(_:)), name: .didGotCompanyAppToken, object: nil)
        
        // You can create a transition with the getTransition func provided by Silt
        //view.window!.layer.add(getTransition(subtype: .fromRight), forKey: kCATransition)
        
        // set the Presentation style of the webview
        vc.modalPresentationStyle = .overFullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        // You can also set default animation
        //self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onFinishedSiltVerification(_ notification: Notification) {
        let siltUserId = notification.userInfo?["siltUserId"] as? String
        let siltCompanyAppToken = notification.userInfo?["siltCompanyAppToken"] as? String
        if(!(siltUserId!).isEmpty && !(siltCompanyAppToken!).isEmpty){
            // Call your backend here to verify this userId
            print("Got a verified user Id: \(siltUserId!) \(siltCompanyAppToken!)")
        }
    }
    
    
    
}

