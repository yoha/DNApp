//
//  StoryTableViewCell.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/31/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate: class {
    func StoryTableViewCellDelegateUpvoteButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject)
    func StoryTableViewCellDelegateCommentButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject)
}

class StoryTableViewCell: UITableViewCell {

    // MARK: - Stored Properties
    
    weak var delegate: StoryTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties

    @IBOutlet var badgeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var upvoteButton: SpringButton!
    @IBOutlet var commentButton: SpringButton!
    
    // MARK: - IBAction Properties
    
    @IBAction func upvoteButtonDidTouch(sender: SpringButton) {
        sender.animation = "swing"
        sender.force = 3.0
        sender.animate()
        
        self.delegate?.StoryTableViewCellDelegateUpvoteButtonDidTouch(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTouch(sender: SpringButton) {
        self.commentButton.animation = "pop"
        self.commentButton.animate()
        
        self.delegate?.StoryTableViewCellDelegateCommentButtonDidTouch(self, sender: sender)
    }
}
