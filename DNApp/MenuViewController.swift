//
//  MenuViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet var dialogView: DesignableView!
    
    // MARK: - IBAction Properties
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dialogView.animation = "fall"
        self.dialogView.animate()
    }
}
