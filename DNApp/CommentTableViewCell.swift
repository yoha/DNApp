//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/6/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate: NSObjectProtocol {
    func commentTableViewCellUpvoteButtonDidTouch(cell: CommentTableViewCell)
    func commentTableViewCellCommentButtonDidTouch(cell: CommentTableViewCell)
}

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Stored Properties
    
    weak var delegate: CommentTableViewCellDelegate?

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    // MARK: - IBAction Properties
    
    @IBAction func upvoteButtonDidTouch(sender: SpringButton) {
        self.delegate?.commentTableViewCellUpvoteButtonDidTouch(self)
    }
    
    @IBAction func replyButtonDidTouch(sender: SpringButton) {
        self.delegate?.commentTableViewCellCommentButtonDidTouch(self)
    }
    
    // MARK: - Local Methods
    
    func configureCellWithComment(comment: JSON) {
        let avatar = comment["user_portrait_url"].string
        let avatarUrl = avatar?.toURL()
        self.avatarImageView.setURL(avatarUrl, placeholderImage: UIImage(named: "content-avatar-default"))
        
        let userDisplayName = comment["user_display_name"].string ?? ""
        self.authorLabel.text = userDisplayName
        
        let jobTitle = comment["user_job"].string ?? ""
        self.authorLabel.text = userDisplayName + "," +  "\(jobTitle)"
        
        guard let validVoteCount = comment["vote_count"].int else { return }
        self.upvoteButton.setTitle("\(validVoteCount)", forState: UIControlState.Normal)

        guard let validCreatedAt = comment["created_at"].string else { return }
        self.timeLabel.text = timeAgoSinceDate(dateFromString(validCreatedAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
    
        guard let validCommentTextView = self.commentTextView else { return }
        guard let validComment = comment["body"].string else { return }
        validCommentTextView.text = validComment
        let bodyHTML = comment["body_html"].string ?? ""
        validCommentTextView.attributedText = htmlToAttributedString(bodyHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
    }
    
}
