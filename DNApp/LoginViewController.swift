//
//  LoginViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/28/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet & IBAction Properties
    
    @IBOutlet var dialogView: DesignableView!
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        self.dialogView.animation = "shake"
        self.dialogView.animate()
    }
    
    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
