//
//  LoginViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/28/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet & IBAction Properties
    
    @IBOutlet var dialogView: DesignableView!
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        self.dialogView.animation = "shake"
        self.dialogView.animate()
    }
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
    }

}
