//
//  WebViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 25/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    var storeUrl: String = ""
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL (string: storeUrl)!
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
        displayLoadingDialog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoadingDialog()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideLoadingDialog()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
