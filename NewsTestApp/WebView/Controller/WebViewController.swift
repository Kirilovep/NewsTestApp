//
//  WebViewController.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import UIKit
import WebKit
class WebViewController: UIViewController, WKNavigationDelegate {
    
    //MARK: - Properties -
    var webView: WKWebView!
    var urlString: String?
    
    
    //MARK: - LifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        loadWebView(url: urlString ?? " ")
        
    }
    
    //MARK: - Functions -
    func loadWebView(url: String) {
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
}
