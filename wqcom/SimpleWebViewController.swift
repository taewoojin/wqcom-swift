//
//  SimpleWebViewController.swift
//  wqcom
//
//  Created by 진용호 on 2017. 9. 7..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import UIKit

class SimpleWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
//    @IBOutlet weak var webView: UIWebView!
    
    var url: URL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        goBackButton.isEnabled = false
//        goBackButton.tintColor = UIColor.clear
//        goForwardButton.isEnabled = false
//        goForwardButton.tintColor = UIColor.clear
//        
//        webView!.delegate = self
//        webView!.scrollView.showsHorizontalScrollIndicator = false
//        webView!.scrollView.bounces = false
//        webView!.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0)
//        
//        loadRequest(url!)
    }

    func loadRequest(_ requestUrl: URL) {
        let request = NSMutableURLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        request.addValue(Device.DeviceType, forHTTPHeaderField: "deviceType")
//        request.addValue(Device.AppVersion, forHTTPHeaderField: "version")
//        webView?.loadRequest(request as URLRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        goBackButton.isEnabled = webView.canGoBack
//        goForwardButton.isEnabled = webView.canGoForward
//        
//        return false
//    }

//    // 2. 웹뷰가 일을 하기 시작했으면
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        goBackButton.isEnabled = webView.canGoBack
//        goForwardButton.isEnabled = webView.canGoForward
//    }
//    
//    // 3. 성공적으로 일을 끝내면
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        goBackButton.isEnabled = webView.canGoBack
//        goForwardButton.isEnabled = webView.canGoForward
//    }
//    
//    // 3. 실패로 일을 끝내면
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        print("[Webview] fail with error \(error)");
//        
//        goBackButton.isEnabled = webView.canGoBack
//        goForwardButton.isEnabled = webView.canGoForward
//    }
    
}
