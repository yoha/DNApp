//
//  ReplyViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/27/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    // MARK: - Stored Properties
    
    var story: JSON = []
    var comment: JSON = []
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var replyTextView: UITextView!
    
    // MARK: - IBAction Properties
    
    @IBAction func sendButtonDidTouch(sender: UIButton) {
        
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replyTextView.becomeFirstResponder()
    }

}
