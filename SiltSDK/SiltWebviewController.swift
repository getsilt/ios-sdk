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
}

public class SiltWebviewController: UIViewController, WKUIDelegate {
    let siltSignupURL: String
    public var siltWebview: WKWebView!
    
    public init (companyAppId: String!) {
        siltSignupURL = "https://signup.getsilt.com/?company_app_id=" + companyAppId
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        siltSignupURL = "https://signup.getsilt.com/?company_app_id="
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        sendRequest(urlString: siltSignupURL)
    }
    
    var siltVerifiedUserId: String? {
        didSet(value) {
            NotificationCenter.default.post(name: .didFinishedSiltVerification, object: nil, userInfo: ["siltVerifiedUserId": siltVerifiedUserId!])
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
        if keyPath == #keyPath(WKWebView.url) {
            let verified_user_id = getQueryStringParameter(url: siltWebview.url!, param: "verified_user_id")
            if (!verified_user_id.isEmpty) {
                siltVerifiedUserId = verified_user_id
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
            self.view.window!.layer.add(getTransition(subtype: .fromLeft), forKey: nil)
            self.dismiss(animated: false, completion: nil)
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
