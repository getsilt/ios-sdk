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
        let vc = SiltWebviewController(url: "https://signup.getsilt.com/?customer_app_id=YOUR_CUSTOMER_APP_ID")
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        NotificationCenter.default.addObserver(self, selector: #selector(onVerifiedUserId(_:)), name: .didFinishedSiltVerification, object: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onVerifiedUserId(_ notification: Notification) {
        if let siltVerifiedUserId = notification.userInfo?["siltVerifiedUserId"] as? String{
            if(!siltVerifiedUserId.isEmpty){
                // Call your backend here to verify this userId
                print("Got a verified user Id: \(siltVerifiedUserId)")
            }
        }
        
    }
    
    
    
}

