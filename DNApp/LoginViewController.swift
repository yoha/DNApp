//
//  LoginViewController.swift
//  DNApp
//
//  Created by Yohannes Wijaya on 12/28/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutletProperties
    
    @IBOutlet var dialogView: DesignableView!
    @IBOutlet weak var emailIconImageView: SpringImageView!
    @IBOutlet weak var passwordIconImageView: SpringImageView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    // MARK: - IBAction Properties
    
    @IBAction func loginButtonDidTouch(sender: UIButton) {
        guard let validTextFieldEntryForEmail = self.emailTextField.text else { return }
        guard let validTextFieldEntryForPassword = self.passwordTextField.text else { return }
        
        guard validTextFieldEntryForEmail.characters.contains("@") && validTextFieldEntryForEmail.characters.contains(".") else {
            self.dialogView.animation = "shake"
            self.dialogView.animate()
            return
        }
        DNService.loginWithEmail(validTextFieldEntryForEmail, password: validTextFieldEntryForPassword) { (token) -> () in
            guard let validToken = token else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
                return
            }
            LocalDefaults.saveToken(validToken)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func closeButtonDidTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dialogView.animation = "zoomOut"
        self.dialogView.animate()
    }
    
    // MARK: - UIResponder Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.emailTextField {
            self.emailIconImageView.image = UIImage(named: "icon-mail-active")
            self.emailIconImageView.animate()
        }
        else {
            self.emailIconImageView.image = UIImage(named: "icon-mail")
        }
        
        if textField == self.passwordTextField {
            self.passwordIconImageView.image = UIImage(named: "icon-password-active")
            self.passwordIconImageView.animate()
        }
        else {
            self.passwordIconImageView.image = UIImage(named: "icon-password")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.emailIconImageView.image = UIImage(named: "icon-mail")
        self.passwordIconImageView.image = UIImage(named: "icon-password")
    }
}
