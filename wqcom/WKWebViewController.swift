//
//  WKWebViewController.swift
//  wqcom
//
//  Created by 진용호 on 2017. 9. 25..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, GDWebViewControllerDelegate {

    var url: URL? = nil
    var webView: WKWebView!
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Private Properties
    var webVC = GDWebViewController()
    var navVC = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
////        let myBlog = "https://iosdevcenters.blogspot.com/"
////        let url = NSURL(string: self.url)
//        let request = NSURLRequest(url: url!)
//        
//        // init and load request in webview.
//        webView = WKWebView(frame: self.view.frame)
////        webView.navigationDelegate = self
//        webView.load(request as URLRequest)
//        self.view.addSubview(webView)
//        self.view.sendSubview(toBack: webView)
////        webView.allowsBackForwardNavigationGestures = true
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navVC.setViewControllers([webVC], animated: false)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        webVC.delegate = self
//        webVC.loadURLWithString(gHost)
        webVC.loadURL(self.url!)
        webVC.toolbar.toolbarTintColor = UIColor.darkGray
        webVC.toolbar.toolbarBackgroundColor = UIColor.white
        webVC.toolbar.toolbarTranslucent = false
        webVC.allowsBackForwardNavigationGestures = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.webVC.showToolbar(true, animated: true)
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }

    
    
}
