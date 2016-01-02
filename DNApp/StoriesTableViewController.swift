//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate {
    
    // MARK: - IBAction Methods
    
    @IBAction func menuButtonDidTouch(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("menuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    // MARK: - UITableViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! StoryTableViewCell
        cell.badgeImageView.image = UIImage(named: "badge-apple")
        cell.titleLabel.text = "Learn iOS Design & Xcode"
        cell.avatarImageView.image = UIImage(named: "content-avatar-default")
        cell.authorLabel.text = "Yohannes Wijaya: Coder & Designer"
        cell.timeLabel.text = "1h"
        cell.upvoteButton.setTitle("123", forState: UIControlState.Normal)
        cell.commentButton.setTitle("321", forState: .Normal)
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("webSegue", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - StoryTableViewCellDelegate Methods
    
    func StoryTableViewCellDelegateUpvoteButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject) {
        // TODO: - implement upvote
    }
    
    func StoryTableViewCellDelegateCommentButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject) {
        self.performSegueWithIdentifier("commentsSegue", sender: cell)
    }
}
