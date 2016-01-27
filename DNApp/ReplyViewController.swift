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
        self.view.showLoading()
        
        guard let validToken = LocalDefaults.loadToken() else { return }
        guard let validReply = self.replyTextView.text where !validReply.isEmpty else { return }
        
        if let validStoryID = self.story["id"].int {
            DNService.replyStoryWithID(validStoryID, token: validToken, body: validReply, responseAsClosure: { [unowned self] (successful) -> () in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    // showAlert
                }
            })
        }
        else if let validCommentID = self.comment["id"].int {
            DNService.replyCommentWithID(validCommentID, token: validToken, body: validReply, responseAsClosure: { [unowned self] (successful) -> () in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    // showAlert
                }
            })
        }
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replyTextView.becomeFirstResponder()
    }

}
