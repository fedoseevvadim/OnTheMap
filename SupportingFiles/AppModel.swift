//
//  OnTheMapStruct.swift
//  On_the_map
//
//  Created by Вадим Федосеев on 24.10.2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation
import UIKit

struct AppModel {
    
    static let udacitySignupURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    static let appName          = "On The Map"
    static let titleAction      = "Ok"

    static let udacityApiPath   = "https://www.udacity.com/api/session"
    static let udacityUsername  = "username"
    static let udacityPassword  = "password"
    static let udacity          = "udacity"
    
    struct alert {

        static let alertTitle               = "Discard"
        static let alertMessageEnterEmail   = "Please enter your email."
        static let alertMessageEnterPass    = "Please enter your password."
        
    }
    
}

func showAlert (message: String, parent: UIViewController) {
    
    let alert = UIAlertController.init(title: AppModel.appName, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: AppModel.titleAction, style: .default, handler: nil)
    alert.addAction(alertAction)
    parent.present(alert, animated: true, completion: nil)
    
}

func showActivityIndicatory(show: Bool, parent:UIView) {
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    activityIndicatorView.alpha     = 1
    activityIndicatorView.center    = CGPoint(x: parent.frame.width/2, y: parent.frame.height/2)
    
    if show {
        activityIndicatorView.startAnimating()
        parent.addSubview(activityIndicatorView)
    } else {
        activityIndicatorView.stopAnimating()
        parent.willRemoveSubview(activityIndicatorView)
    }
    
}

class UdacityClient {
    
    func login (email: String, password: String, completion: @escaping (_ error: NSError? ) -> Void ) {
        
        let request             = NSMutableURLRequest(url: URL(string: AppModel.udacityApiPath)!)
        let fieldsDictionary    = NSMutableDictionary()
        let udacityDictionary   = NSMutableDictionary()
        
        request.httpMethod  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        fieldsDictionary.setValue(email, forKey: AppModel.udacityUsername)
        fieldsDictionary.setValue(password, forKey: AppModel.udacityPassword)
        
        udacityDictionary.setValue(fieldsDictionary, forKey: AppModel.udacity)

    }
    
    func logOut () {
        
        
    }

}




