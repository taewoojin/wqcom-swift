//
//  TestViewController.swift
//  Wqcom
//
//  Created by 진용호 on 2017. 9. 20..
//  Copyright © 2017년 jjlee. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url: URL? = URL(string: Url.Base)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        loadRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func loadRequest() {
        
            let url = self.url!
        
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
            
            webView?.loadRequest(request as URLRequest)
            
        
    }

    
    
}
