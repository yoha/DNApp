//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate {
    
    // MARK - Stored Properties
    
    var article: JSON!
    var comments: JSON!
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
        if let storyCell = cell as? StoryTableViewCell {
            storyCell.configureCellWithArticle(self.article)
            storyCell.delegate = self
        }
        else if let commentCell = cell as? CommentTableViewCell {
            let commentAtIndex = self.comments[indexPath.row - 1]
            commentCell.configureCellWithComment(commentAtIndex)
            commentCell.delegate = self
        }
        return cell
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.comments = self.article["comments"]
    
    }

    // MARK: - CommentTableViewCellDelegate Methods
    
    func commentTableViewCellUpvoteButtonDidTouch(cell: CommentTableViewCell) {
        
    }
    
    func commentTableViewCellCommentButtonDidTouch(cell: CommentTableViewCell) {
        <#code#>
    }
    
    // MARK: - StoryTableViewCellDelegate
    
    func StoryTableViewCellUpvoteButtonDidTouch(cell: StoryTableViewCell) {
        <#code#>
    }
    
    func StoryTableViewCellCommentButtonDidTouch(cell: StoryTableViewCell) {
        <#code#>
    }
}
