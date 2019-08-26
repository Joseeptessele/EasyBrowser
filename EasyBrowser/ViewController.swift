//
//  ViewController.swift
//  EasyBrowser
//
//  Created by José Eduardo Pedron Tessele on 22/08/19.
//  Copyright © 2019 José P Tessele. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var website: String = ""
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = [String]()
    override func loadView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backNavigation = UIBarButtonItem(title: "Back", style: .plain, target: self, action:  #selector(goBack))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let forwardNavigation = UIBarButtonItem(title: "Forward", style: .plain, target: self, action:  #selector(goForward))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [backNavigation ,spacer, progressButton, spacer, forwardNavigation]
        navigationController?.isToolbarHidden = false
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://\(website)") else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // for ipad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func goForward(){
        if webView.canGoForward{
            webView.goForward()
        } else {
            
        }
    }
    
    @objc func goBack(){
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://\(actionTitle)") else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title!
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        for website in websites{
            print("\(website) <---")
        }

        let url = navigationAction.request.url
        if let allowedHost = url?.host {
            for website in websites {
                if allowedHost.contains(website){
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        
        if let notAllowedHost = url?.host {
            for website in websites {
                if !notAllowedHost.contains(website){
                    print("\(website) = \(notAllowedHost)")
                    showAlert()
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        
    }

    func showAlert(){
        let ac = UIAlertController(title: "Warning", message: "This website is not allowed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

