//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate, ReplyViewControllerDelegate {
    
    // MARK - Stored Properties
    
    var article: JSON!
    var comments: [JSON]!
    
    var transitionManager = TransitionManager()
    
    // MARK: - IBAction Properties
    
    @IBAction func actionBarButtonItemDidTouch(sender: UIBarButtonItem) {
        let articleTitle = self.article["title"].string ?? ""
        let articleUrl = self.article["url"].string ?? ""
        
        let activityViewController = UIActivityViewController(activityItems: [articleTitle, articleUrl], applicationActivities: nil)
        activityViewController.setValue(articleTitle, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
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
        
        self.comments = self.flattenComments(self.article["comments"].array ?? [])
        
        self.refreshControl?.addTarget(self, action: "reloadStory", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "replyCommentSegue",
                let validDestinationViewController = segue.destinationViewController as? ReplyViewController else { return }
        if let commentTableViewCell = sender as? CommentTableViewCell {
            guard let validIndexPath = self.tableView.indexPathForCell(commentTableViewCell) else { return }
            let commentToBePassed = self.comments[validIndexPath.row - 1]
            validDestinationViewController.comment = commentToBePassed
        }
        else if let _ = sender as? StoryTableViewCell {
            validDestinationViewController.story = self.article
        }
        validDestinationViewController.delegate = self
        validDestinationViewController.transitioningDelegate = transitionManager
    }

    // MARK: - CommentTableViewCellDelegate Methods
    
    func commentTableViewCellUpvoteButtonDidTouch(cell: CommentTableViewCell) {
        guard let validToken = LocalDefaults.loadToken() else {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
            return
        }
        guard let validIndexPath = self.tableView.indexPathForCell(cell) else { return }
        let comment = self.comments[validIndexPath.row - 1]
        guard let validCommentID = comment["id"].int else { return }
        
        DNService.upvoteCommentWithID(validCommentID, token: validToken) { (successful) -> () in
            // Optionally do something here
        }
        
        LocalDefaults.saveUpvotedComment(validCommentID)
        cell.configureCellWithComment(comment)
    }
    
    func commentTableViewCellCommentButtonDidTouch(cell: CommentTableViewCell) {
        if LocalDefaults.loadToken() != nil {
            self.performSegueWithIdentifier("replyCommentSegue", sender: cell)
        }
        else {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    // MARK: - StoryTableViewCellDelegate Methods
    
    func StoryTableViewCellUpvoteButtonDidTouch(cell: StoryTableViewCell) {
        guard let validToken = LocalDefaults.loadToken() else {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
            return
        }
        guard let validArticleID = self.article["id"].int else { return }
        
        DNService.upvoteStoryWithID(validArticleID, token: validToken) { (successful) -> () in
            // Optionally do something here
        }
        
        LocalDefaults.saveUpvotedStory(validArticleID)
        cell.configureCellWithArticle(self.article)
    }
    
    func StoryTableViewCellCommentButtonDidTouch(cell: StoryTableViewCell) {
        if LocalDefaults.loadToken() != nil {
            self.performSegueWithIdentifier("replyCommentSegue", sender: cell)
        }
        else {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    // MARK: - ReplyViewControllerDelegate Methods
    
    func replyViewControllerReplyButtonDidTouch(controller: ReplyViewController) {
        self.reloadStory()
    }
    
    // MARK: - Local Methods
    
    func reloadStory() {
        self.view.showLoading()
        DNService.getStoryForID(self.article["id"].int!) { [unowned self] (response: JSON) -> () in    
            self.article = response["story"]
            self.comments = self.flattenComments(response["story"]["comments"].array ?? [])

            self.tableView.reloadData()
            
            self.view.hideLoading()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func flattenComments(comments: [JSON]) -> [JSON] {
        let flattenedComments = comments.map(commentsForComment).reduce([], combine: +)
        return flattenedComments
    }
    
    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]) { acc, x in
            acc + self.commentsForComment(x)
        }
    }
}
