//
//  WebviewController.swift
//  silt-sdk-storyboard
//
//  Created by Marc on 21/04/2020.
//  Copyright © 2020 Silt. All rights reserved.
//


import UIKit
import WebKit

public func getTransition(subtype: CATransitionSubtype) -> CATransition {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = subtype
    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    return transition
}

private func getQueryStringParameter(url: URL, param: String) -> String {
    guard let url = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return "" }
    return url.queryItems?.first(where: { $0.name == param })?.value  ?? ""
}

public extension Notification.Name {
    static let didFinishedSiltVerification = Notification.Name("didFinishedSiltVerification")
    static let didGotSiltUserID = Notification.Name("didGotSiltUserID")
    static let didGotCompanyAppToken = Notification.Name("didGotCompanyAppToken")
}

public class SiltWebviewController: UIViewController, WKUIDelegate {
    let siltSignupURL: String
    var outTransition: CATransitionSubtype?
    public var siltWebview: WKWebView!
    
    public init (companyAppId: String!, outTransition: CATransitionSubtype? = nil) {
        siltSignupURL = "https://signup.getsilt.com/?company_app_id=" + companyAppId
        self.outTransition = outTransition
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        siltSignupURL = "https://signup.getsilt.com/?company_app_id="
        self.outTransition = .fromBottom
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        sendRequest(urlString: siltSignupURL)
    }
    
    var siltUserId: String? {
        didSet(value) {
            if (siltUserId) != nil {
                NotificationCenter.default.post(name: .didGotSiltUserID, object: nil, userInfo: ["siltUserId": siltUserId ?? "", "siltCompanyAppToken": siltCompanyAppToken ?? ""])
            }

        }
    }
    
    var siltCompanyAppToken: String? {
        didSet(value) {
            if (siltCompanyAppToken) != nil {
                NotificationCenter.default.post(name: .didGotCompanyAppToken, object: nil, userInfo: ["siltUserId": siltUserId ?? "", "siltCompanyAppToken": siltCompanyAppToken ?? ""])
            }
        }
    }
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        siltWebview = WKWebView(frame: .zero, configuration: webConfiguration)
        siltWebview.uiDelegate = self
        siltWebview.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        siltWebview.addGestureRecognizer(swipeLeftRecognizer)
        siltWebview.addGestureRecognizer(swipeRightRecognizer)
        view = siltWebview
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) && siltWebview.url != nil {
            
            
            
            let silt_user_id = getQueryStringParameter(url: siltWebview.url!, param: "silt_user_id")
            
            if (!silt_user_id.isEmpty) {
                siltUserId = silt_user_id
            }
            
            let company_app_token = getQueryStringParameter(url: siltWebview.url!, param: "company_app_token")
            if (!company_app_token.isEmpty) {
                siltCompanyAppToken = company_app_token
            }
            
            if keyPath == #keyPath(WKWebView.url) {
                if ((siltWebview.url!).path == "/finished-verification" ) {
                    if (siltCompanyAppToken) != nil && (siltUserId) != nil {
                        NotificationCenter.default.post(name: .didFinishedSiltVerification, object: nil, userInfo: ["siltUserId": siltUserId!, "siltCompanyAppToken": siltCompanyAppToken!])
                    }
                    if (self.outTransition != nil) {
                        self.view.window!.layer.add(getTransition(subtype: self.outTransition!), forKey: nil)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    // Convert String into URL and load the URL
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        siltWebview.load(myRequest)
    }
    
    
    @objc private func goBack() {
        if siltWebview.canGoBack {
            siltWebview.goBack()
        } else {
            if (self.outTransition != nil) {
                self.view.window!.layer.add(getTransition(subtype: self.outTransition!), forKey: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
            if siltWebview.canGoForward {
                siltWebview.goForward()
            }
        }
        
        if (recognizer.direction == .right) {
            goBack()
        }
    }
}
//extension WebviewController {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.showActivityIndicator(show: false)
//    }
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        // Set the indicator everytime webView started loading
//        self.showActivityIndicator(show: true)
//    }
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        self.showActivityIndicator(show: false)
//    }
//}
