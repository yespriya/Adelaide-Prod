//
//  PrivacyPolicyView.swift
//  Adelaide Prod
//
//  Created by Prit  on 31/01/26.
//


import UIKit
import WebKit

class PrivacyPolicyView: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlToLoad = String()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        webView.navigationDelegate = self
        
        if let url = URL(string: urlToLoad) {
            let request = URLRequest(url: url)
            webView.load(request)
            activityIndicator.startAnimating()
        }
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    @IBAction func onCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        self.showAlert("URL loading error.")
        self.dismiss(animated: true)
    }
    
}
