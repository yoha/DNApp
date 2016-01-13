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
    
    let data = Data()
    
    weak var delegate: StoryTableViewCellDelegate?
    
    // MARK: - IBOutlet Properties

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    // MARK: - IBAction Properties
    
    @IBAction func upvoteButtonDidTouch(sender: SpringButton) {
        sender.animation = "swing"
        sender.force = 3.0
        sender.animate()
        
        self.delegate?.StoryTableViewCellDelegateUpvoteButtonDidTouch(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTouch(sender: SpringButton) {
        self.delegate?.StoryTableViewCellDelegateCommentButtonDidTouch(self, sender: sender)
    }
    
    // MARK: - Local Methods
    
    func configureCellWithArticle(article: JSON) {
        
        guard let validTitle = article["title"].string else { return }
        self.titleLabel.text = validTitle
        
        let badge = article["badge"].string ?? ""
        self.badgeImageView.image = UIImage(named: "badge-" + badge )

        guard let validAvatar = article["user_portrait_url"].string else { return }
        guard let validAvatarUrl = validAvatar.toURL() else { return }
        self.avatarImageView.setURL(validAvatarUrl, placeholderImage: UIImage(named: "content-avatar-default"))
        
        let userDisplayName = article["user_display_name"].string ?? ""
        self.authorLabel.text = userDisplayName
        
        let jobTitle = article["user_job"].string ?? ""
        self.authorLabel.text = userDisplayName + ", " + jobTitle
        
        guard let validCreatedAt = article["created_at"].string else { return }
        self.timeLabel.text = timeAgoSinceDate(dateFromString(validCreatedAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        
        guard let validVoteCount = article["vote_count"].int else { return }
        self.upvoteButton.setTitle("\(validVoteCount)", forState: UIControlState.Normal)
       
        guard let validCommentCount = article["comment_count"].int else { return }
        self.commentButton.setTitle("\(validCommentCount)", forState: .Normal)
        
        guard let validCommentTextView = self.commentTextView else { return }
        guard let validComment = article["comment"].string else { return }
        validCommentTextView.text = validComment
    }
}
