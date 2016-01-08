//
//  WebViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    // MARK: - IBAction Properties
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    // MARK: - Stored Properties
    
    var url: String!
    var hasFinishedLoading = false
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        guard let targetUrl = NSURL(string: self.url) else { return }
        let targetUrlRequest = NSURLRequest(URL: targetUrl)
        self.webView.loadRequest(targetUrlRequest)
        
    }
    
    deinit {
        self.webView.stopLoading()
        self.webView.delegate = nil
    }
    
    // MARK: - UIWebViewDelegate Methods
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.hasFinishedLoading = false
        self.updateProgressView()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        delay(1.0) { [weak self] () -> () in
            if let _self = self { _self.hasFinishedLoading = true }
        }
    }
    
    // MARK: - Local Methods
    
    func updateProgressView() {
        if self.progressBarView.progress >= 1 { self.progressBarView.hidden = true }
        else {
            if self.hasFinishedLoading { self.progressBarView.progress += 0.002 }
            else {
                switch self.progressBarView.progress {
                case 0..<0.31:
                    self.progressBarView.progress += 0.004
                case 0.31..<0.61:
                    self.progressBarView.progress += 0.002
                case 0.61..<0.91:
                    self.progressBarView.progress += 0.001
                case 0.91..<0.95:
                    self.progressBarView.progress += 0.0001
                default:
                    self.progressBarView.progress = 0.9401
                }
            }
        }
        delay(0.008) { [weak self] () -> () in
            if let _self = self { _self.updateProgressView() }
        }
    }
}
