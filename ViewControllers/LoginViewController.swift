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
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let url = URL(string: AppModel.udacitySignUp) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        emailField.text         = ""
        passwordField.text      = ""
        loginButton.isEnabled   = true
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {

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
        
        //Utils.shared().showActivityIndicator(show: true, parent: self.view)
        
        UdacityClient.sharedInstance().login(email: email, password: password) { (result, error) in

            guard error == nil else {
                self.showError(message: error ?? AppModel.alert.alertErrorLogin)
                return
            }
            
            guard let result = result else {
                self.showError(message: AppModel.error.resultIsNil)
                return
            }
            
            let range = (5 ..< result.count)
            let correctedData = result.subdata(in: range)
            var loginDict: Dictionary<String, AnyObject>
            
            do {
                loginDict = try JSONSerialization.jsonObject(with: correctedData, options: .allowFragments) as! [String : AnyObject]
            } catch {
                self.showError(message: AppModel.error.jsonSerializationFailed)
                return
            }
            
            let accountDict = loginDict["account"] as? [String : AnyObject?]
            
            guard let accountInfo = accountDict else {
                self.showError(message: AppModel.error.accountIDisMissing)
                return
            }
            
            let userID = accountInfo["key"] as? String
            
            guard userID != nil else {
                self.showError(message: AppModel.error.userIdIsMissing)
                return
            }
            
            UdacityClient.sharedInstance().getStudentData(userID!) { (data, error) in

                guard error == nil else {
                    self.showError(message: error ?? AppModel.error.errorReturnStudentDetails)
                    return
                }

                guard let data = data else {
                    self.showError(message: "Nil result returned from student details call")
                    return
                }

                var dataDict: Dictionary<String, AnyObject>
                //var userDict: Dictionary<String, AnyObject>
                do {
                    dataDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : AnyObject]
                    //userDict = dataDict["user"] as! [String : AnyObject]
                    let loggedIn = ["firstName": dataDict["first_name"] as! String,
                                    "lastName": dataDict["last_name"] as! String,
                                    "userId": userID!] as [String: AnyObject]

                    StudentStruct.loggedInStudent = StudentInformation(loggedIn)
                } catch {
                    self.showError(message: AppModel.error.jsonSerializationFailedStudent)
                    return
                }
//                //Student data fetch is done - go to next screen
                DispatchQueue.main.async {
                    print("Student: \(StudentStruct.loggedInStudent?.firstName) \(StudentStruct.loggedInStudent?.lastName), \(StudentStruct.loggedInStudent?.userId) ")
                    //Utils.shared().showActivityIndicator(show: false, parent: self.view)
                    self.performSegue(withIdentifier: "logInto", sender: self)
                }
                
            }

        }

    }
    
    func showError(message: String) {
        
        DispatchQueue.main.async {
            //Utils.shared().showActivityIndicator(show: false, parent: self.view)
            showAlert(message: message, parent: self)
            self.loginButton.isEnabled = true
        }
        
    }
    
}
