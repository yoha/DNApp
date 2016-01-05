//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate {
    
    // MARK: - Stored Properties
    
    let data = Data()
    
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
        return self.data.jsonData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! StoryTableViewCell
        let article = self.data.jsonData[indexPath.row]
        cell.configureCellWithArticle(article)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("webSegue", sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UIViewController Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "commentsSegue" else { return }
        guard let validDestinationContoller = segue.destinationViewController as? CommentsTableViewController else { return }
        guard let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) else { return }
        validDestinationContoller.article = self.data.jsonData[indexPath.row]
    }
    
    // MARK: - StoryTableViewCellDelegate Methods
    
    func StoryTableViewCellDelegateUpvoteButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject) {
        // TODO: - implement upvote
    }
    
    func StoryTableViewCellDelegateCommentButtonDidTouch(cell: StoryTableViewCell, sender: AnyObject) {
        self.performSegueWithIdentifier("commentsSegue", sender: cell)
    }
}
