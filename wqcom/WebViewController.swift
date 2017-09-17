//
//  WebViewController.swift
//  wqcom
//
//  Created by 진용호 on 2017. 8. 29..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import UIKit
import SpringIndicator
import ESPullToRefresh

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var flexibleSpace: UIBarButtonItem!
    
    var url: URL? = URL(string: Url.Base)
    
    // 오랫동안 요청이 안올 경우 refresh하기 위한 요청시각
    fileprivate var requestTime: Date = Date()
    fileprivate var isFirst = true;
    
    var loadingIndicator: SpringIndicator?
    let refreshControl = SpringIndicator.Refresher()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.backgroundColor = .white
        
        // 상단 누르면 스크롤 to top
//        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WebViewController.respondToTapGesture(_:))))
        
        webView.delegate = self

        // 첫 번째 navigationController면 toolBar를 숨기고 그렇지 않으면 보여준다.
        let count = (navigationController?.viewControllers.count)!
        if count <= 1 {
            webView?.scrollView.showsVerticalScrollIndicator = false
            
            toolbar.isHidden = true
            toolbarHeightConstraint.constant = 0.0
            
        } else {
            webView?.scrollView.showsVerticalScrollIndicator = true
            
            // toolbar의 default border 제거
            toolbar.clipsToBounds = true
            
            let lineWidth: CGFloat = 1.0
            let indent: CGFloat = 10.0
            
            // top view layer
            let topLayer = CALayer()
            topLayer.frame = CGRect(x: indent, y: 0, width: ScreenSize.SCREEN_WIDTH - 2 * indent, height: lineWidth)
            topLayer.backgroundColor = Color.Primary.cgColor
            toolbar.layer.addSublayer(topLayer)
            
            toolbar.setItems(getToolbarItems(), animated: false)
            
        }
        
        loadRequest()
        initPageRefresh()
        
    }
    
    func getToolbarItems() -> [UIBarButtonItem]? {
        
        if let count = navigationController?.viewControllers.count {
            if count <= 1 {
                return [flexibleSpace!]
            } else if count == 2 {
                return [backButton!, flexibleSpace!]
            } else {
                return [backButton!, forwardButton!, flexibleSpace!]
            }
        } else {
            return [flexibleSpace!]
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func respondToTapGesture(_ sender:UITapGestureRecognizer){
        webView.scrollView.scrollsToTop = true
//        let top:CGPoint = CGPointMake(0, 0); // can also use CGPointZero here
//        webView.scrollView.setContentOffset(top, animated: true)
        
    }
    
    func loadRequest() {
        if !webView.isLoading {
            isFirst = true;
            requestTime = Date()
            var url = self.url!
            if let currentUrl = webView.stringByEvaluatingJavaScript(from: "window.location.href"), currentUrl != "about:blank" {
                url = URL(string: currentUrl)!
            }
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            
            request.addValue(Device.DeviceType, forHTTPHeaderField: "deviceType")
//            request.addValue(Device.AppVersion, forHTTPHeaderField: "version")
            
            webView?.loadRequest(request as URLRequest)
            
        }
    }
    
    func initPageRefresh() {
        
        print("ScreenSize.SCREEN_HEIGHT=======\(ScreenSize.SCREEN_HEIGHT)")
        
        let fakeTopView = UIView(frame: CGRect(x: 0, y: -ScreenSize.SCREEN_HEIGHT, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
        fakeTopView.backgroundColor = UIColor(red:0.20, green:0.78, blue:0.53, alpha:1.0)
        
        webView!.scrollView.addSubview(fakeTopView)
        
        // pull down refresh
        refreshControl.addTarget(self, action: #selector(WebViewController.loadRequest), for: .valueChanged)
        refreshControl.indicator.lineColor = UIColor.white
        refreshControl.indicator.lineWidth = 1.5
        refreshControl.indicator.rotateDuration = 1
        refreshControl.indicator.strokeDuration = 2
        refreshControl.indicator.bounds.origin.y = -10
        
        webView!.scrollView.addSubview(refreshControl)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        refreshControl.endRefreshing()
        
        let count = (navigationController?.viewControllers.count)!
        
        print("count=========\(count)")
        if count >= 2 {
            webView.stringByEvaluatingJavaScript(from: "commonFunction.hideHeader('header.header')")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let simpleWebViewController = segue.destination as? SimpleWebViewController {
            if let url = sender as? String {
                simpleWebViewController.url = URL(string: url)
            }
            else if let params = sender as? [String : String] {
                let url = params["url"]
                simpleWebViewController.url = URL(string: url!)
            }
        }
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
//        let count = (navigationController?.viewControllers.count)!
//        print("count=========\(count)")
        
        // 처음으로 load 하거나 reload
        if isFirst {
            isFirst = false
            return true
        }
        
        let requestUrl = (request.url?.absoluteString)!
        
        // root
//        if requestUrl == Url.Base {
//            navigationController!.popToRootViewController(animated: true)
//            return false
//        }
        if (requestUrl == Url.Base
            || requestUrl == "\(Url.Base)/"
            || requestUrl.hasPrefix(Url.Survey)
            || requestUrl == Url.Inquiry
            || requestUrl.hasPrefix(Url.Payment)
            || requestUrl == Url.Review
            || requestUrl.hasPrefix(Url.Setting)) {
            return true
        }
        else if (requestUrl == Url.SignIn
            || requestUrl == Url.NewBlogger) {
//            navigationController!.popToRootViewController(animated: true)
            return true
        }
            
        else if request.url?.scheme == "jscall" {
            return false
        }
        else if requestUrl == "about:blank" {
            return false
        }
        // refresh
        else if requestUrl == Url.Refresh {
            reload()
            return false
        }
        else if !requestUrl.hasPrefix(Url.Base) {
            performSegue(withIdentifier: "SimpleWebViewSegue", sender: requestUrl)
            return false
        }
        
        if !isFirst {
            print("request.url====\(String(describing: request.url))")
            addWebView(request.url)
//            performSegue(withIdentifier: "SimpleWebViewSegue", sender: requestUrl)
            return false
        }
        
        return false
    }
    
    func reload() {
        if !webView.isLoading {
//            addLoadingIndicator()
            loadRequest()
        }
    }
    
    func addWebView(_ url: URL?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(withIdentifier: "webView") as! WebViewController
        webViewController.url = url
        webViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }
}

