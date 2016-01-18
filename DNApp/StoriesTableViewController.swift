//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, MenuviewControllerDelegate, LoginViewControllerDelegate {
    
    // MARK: - Stored Properties
    
    let data = Data()
    
    let transitionManager = TransitionManager()
    
    var articles: JSON = []
    
    var isFirstTimeLoading = true
    
    var articleSection = ""
    
    // MARK: - IBAction Methods
    
    @IBAction func menuButtonDidTouch(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("menuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! StoryTableViewCell
        let article = self.articles[indexPath.row]
        cell.configureCellWithArticle(article)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("webSegue", sender: indexPath)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.loadArticlesInSection("", page: 1)
        
        refreshControl?.addTarget(self, action: "refreshStories", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if self.isFirstTimeLoading {
            self.view.showLoading()
            self.isFirstTimeLoading = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentsSegue" {
            guard let validDestinationContoller = segue.destinationViewController as? CommentsTableViewController else { return }
            guard let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) else { return }
            validDestinationContoller.article = self.articles[indexPath.row]
        }
        if segue.identifier == "webSegue" {
            guard let validDestinationViewController = segue.destinationViewController as? WebViewController else { return }
            guard let indexPath = sender as? NSIndexPath else { return }
            guard let validUrlString = self.articles[indexPath.row]["url"].string else { return }
            validDestinationViewController.url = validUrlString

            validDestinationViewController.transitioningDelegate = self.transitionManager
            
            UIApplication.sharedApplication().statusBarHidden = true
        }
        if segue.identifier == "menuSegue" {
            guard let validDestinationController = segue.destinationViewController as? MenuViewController else { return }
            validDestinationController.delegate = self
        }
        
        if segue.identifier == "loginSegue" {
            guard let validDestinationController = segue.destinationViewController as? LoginViewController else { return }
            validDestinationController.delegate = self
        }
    }
    
    // MARK: - LoginViewControllerDelegate Methods
    
    func loginViewControllerDidLogin(controller: LoginViewController) {
        self.refreshStories()
        self.view.showLoading()
    }
    
    // MARK: - MenuViewControllerDelegate Methods
    
    func menuViewControllerTopStoriesButtonDidTouch() {
        self.view.showLoading()
        self.articleSection = ""
        self.loadArticlesInSection(self.articleSection, page: 1)
        self.title = "Top Stories"
    }
    
    func menuViewcontrollerRecentStoriesButtonDidTouch() {
        self.view.showLoading()
        self.articleSection = "recent"
        self.loadArticlesInSection(self.articleSection, page: 1)
        self.navigationItem.title = "Recent Stories"
    }
    
    // MARK: - StoryTableViewCellDelegate Methods
    
    func StoryTableViewCellUpvoteButtonDidTouch(cell: StoryTableViewCell) {
        // TODO: - implement upvote
    }
    
    func StoryTableViewCellCommentButtonDidTouch(cell: StoryTableViewCell) {
        self.performSegueWithIdentifier("commentsSegue", sender: cell)
    }
    
    // MARK: - Local Methods
    
    func loadArticlesInSection(section: String, page: Int) {
        DNService.getStoriesForSection(section, page: page) { [unowned self] (response: JSON) -> () in
            self.articles = response["stories"]
            
            self.tableView.reloadData()
            
            self.view.hideLoading()
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    func refreshStories() {
        self.loadArticlesInSection(self.articleSection, page: 1)
    }
}
