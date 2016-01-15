//
//  MenuViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

protocol MenuviewControllerDelegate: NSObjectProtocol {
    func menuViewControllerTopStoriesButtonDidTouch()
    func menuViewcontrollerRecentStoriesButtonDidTouch()
}

class MenuViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    weak var delegate: MenuviewControllerDelegate?
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet var dialogView: DesignableView!
    
    // MARK: - IBAction Properties
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dialogView.animation = "fall"
        self.dialogView.animate()
    }
    
    @IBAction func topStoriesButtonDidTouch(sender: UIButton) {
        self.delegate?.menuViewControllerTopStoriesButtonDidTouch()
        self.closeButtonDidTouch(sender)
    }
    
    @IBAction func recentStoriesButtonDidTouch(sender: UIButton) {
        self.delegate?.menuViewcontrollerRecentStoriesButtonDidTouch()
        self.closeButtonDidTouch(sender)
    }
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        
    }
}
