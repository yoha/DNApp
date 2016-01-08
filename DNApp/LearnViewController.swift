//
//  LearnViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/28/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {
    
    // MARK: - IBOutlet Properties

    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var bookIconImageView: SpringImageView!
    
    // MARK: - IBAction Properties
    
    @IBAction func learnButtonDidTouch(sender: UIButton) {
        self.bookIconImageView.animation = "pop"
        self.bookIconImageView.animate()
        
        self.openUrl("http://designcode.io")
    }
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dialogView.animation = "fall"
        self.dialogView.animateNext {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func twitterButtonDidTouch(sender: UIButton) {
        self.openUrl("http://twitter.com/mengto")
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.dialogView.animation = "zoomIn"
        self.dialogView.autohide = true
        self.dialogView.animate()
    }
    
    // MARK: - Local Methods
    
    func openUrl(url: String) {
        guard let targetUrl = NSURL(string: url) else { return }
        UIApplication.sharedApplication().openURL(targetUrl)
    }
}
