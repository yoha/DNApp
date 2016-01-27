//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/30/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, LoginViewControllerDelegate, MenuViewControllerDelegate {
    
    // MARK: - Stored Properties
    
    let data = Data()
    
    let transitionManager = TransitionManager()
    
    var articles: JSON = []
    
    var isFirstTimeLoading = true
    
    var articleSection = ""
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
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
    
    func loginViewControllerLoginButtonDidTouch(controller: LoginViewController) {
        self.view.showLoading()
        self.refreshStories()
    }
    
    // MARK: - MenuViewControllerDelegate Methods
    
    func menuViewControllerTopStoriesButtonDidTouch(viewController: MenuViewController) {
        self.view.showLoading()
        self.articleSection = ""
        self.loadArticlesInSection(self.articleSection, page: 1)
        self.title = "Top Stories"
    }
    
    func menuViewcontrollerRecentStoriesButtonDidTouch(viewController: MenuViewController) {
        self.view.showLoading()
        self.articleSection = "recent"
        self.loadArticlesInSection(self.articleSection, page: 1)
        self.navigationItem.title = "Recent Stories"
    }
    
    func menuViewControllerLoginButtonDidTouch(viewController: MenuViewController) {
        self.view.showLoading()
        self.loadArticlesInSection(self.articleSection, page: 1)
    }
    
    // MARK: - StoryTableViewCellDelegate Methods
    
    func StoryTableViewCellUpvoteButtonDidTouch(cell: StoryTableViewCell) {
        guard let validToken = LocalDefaults.loadToken() else {
            self.performSegueWithIdentifier("loginSegue", sender: self)
            return
        }
        guard let validCellIndexPath = self.tableView.indexPathForCell(cell) else { return }
        let article = self.articles[validCellIndexPath.row]
        guard let validArticleID = article["id"].int else { return }
        
        DNService.upvoteStoryWithID(validArticleID, token: validToken) { (successful) -> () in
            // Do something
        }
        
        LocalDefaults.saveUpvotedStory(validArticleID)
        
        cell.configureCellWithArticle(article)
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
        
        self.loginButton.title = LocalDefaults.loadToken() == nil ? "Login" : ""
        self.loginButton.enabled = LocalDefaults.loadToken() == nil ? true : false
    }
    
    func refreshStories() {
        self.loadArticlesInSection(self.articleSection, page: 1)
    }
}
