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
                    self.showAlert()
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
                    self.showAlert()
                }
            })
        }
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.replyTextView.becomeFirstResponder()
    }
    
    // MARK: - Local Methods
    
    private func showAlert() {
        let alert = UIAlertController(title: "Oh..no!!", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
