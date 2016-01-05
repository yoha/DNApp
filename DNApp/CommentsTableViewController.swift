//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 1/5/16.
//  Copyright © 2016 Yohannes Wijaya. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    // MARK - Stored Properties
    
    var article = [String: AnyObject]()
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(article)
    }

}
