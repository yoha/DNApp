//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/6/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    // MARK: - IBAction Properties
    
    @IBAction func upvoteButtonDidTouch(sender: SpringButton) {
        
    }
    
    @IBAction func replyButtonDidTouch(sender: SpringButton) {
        
    }
    
    // MARK: - Local Methods
    
    func configureCellWithComment(comment: JSON) {
        guard let _ = comment["user_portrait_url"].string else { return }
        self.avatarImageView.image = UIImage(named: "content-avatar-default")
        
        guard let validUserDisplayName = comment["user_display_name"].string else { return }
        self.authorLabel.text = validUserDisplayName
        
        guard let validUserJobTitle = comment["user_job"].string else { return }
        self.authorLabel.text! += "," +  "\(validUserJobTitle)"
        
        guard let validVoteCount = comment["vote_count"].int else { return }
        self.upvoteButton.setTitle("\(validVoteCount)", forState: UIControlState.Normal)

        guard let validCreatedAt = comment["created_at"].string else { return }
        self.timeLabel.text = timeAgoSinceDate(dateFromString(validCreatedAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
    
        guard let validComment = comment["body"].string else { return }
        self.commentTextView.text = validComment
    }
    
}
