//
//  LoginViewController.swift
//  On_the_map
//
//  Created by Vadim on 22/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //emailField.delegate = self
        //passwordField.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        emailField.text         = ""
        passwordField.text      = ""
        loginButton.isEnabled   = true
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        //loginButton.isEnabled = false
        
        guard let email = emailField.text,
            email.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                
                showAlert(message: AppModel.alert.alertMessageEnterEmail, parent: self)
                
                return
        }
        
        guard let password = passwordField.text,
            password.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                
                showAlert(message: AppModel.alert.alertMessageEnterPass, parent: self)
                
                return
        }
     
        
        showActivityIndicatory(show: true, parent: self.view)
        
        
    }
    
}
