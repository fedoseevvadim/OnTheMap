//
//  OnTheMapStruct.swift
//  On_the_map
//
//  Created by Вадим Федосеев on 24.10.2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct AppModel {
    
    static let udacitySignupURL                 = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    static let udacityStudentLocation           = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let udacityAppID                     = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let udacityAPIKey                    = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let udacitySignUp                    = "https://www.udacity.com/account/auth#!/signup"
    static let appName                          = "On The Map"
    static let titleAction                      = "Ok"
    static let loginStatus                      = "Login Request: status code is wrong"
    static let noData                           = "Login Request: returned no data"
    static let errorWithLogin                   = "Error with the Login request"
    static let errorWithLogOut                  = "Error with logout request"
    static let errorWithLogOutRequest           = "Logout request status code is bad"
    static let errorWithGetStudentsData         = "Error with getting students data"
    static let errorUnknownErrorWithStudentLoc  = "Unknown error while fetching student locations"
    static let EnterValidURL                    = "Please enter valid website url"
    static let EnterLocation                    = "Please enter location text."
    
    struct udacity {
        
        static let apiPath   = "https://www.udacity.com/api/session"
        static let username  = "username"
        static let password  = "password"
        static let udacity   = "udacity"
        
    }
    
    struct alert {

        static let alertTitle               = "Discard"
        static let alertMessageEnterEmail   = "Please enter your email."
        static let alertMessageEnterPass    = "Please enter your password."
        static let alertErrorLogin          = "Error from Udacity"
        
    }
    
}

// example of JSON data
// ["latitude": 37.386052, "createdAt": 2018-10-31T13:55:31.328Z, "longitude": -122.083851, "firstName": John, "mediaURL": https://udacity.com, "updatedAt": 2018-10-31T13:55:31.328Z, "mapString": Mountain View, CA, "lastName": Doe, "objectId": 8HKXdPJ5Ia, "uniqueKey": 1234]

struct StudentInformation {
    static var students: [studentStruct]?
    static var loggedInStudent: studentStruct?
}

struct studentStruct {
    
    var firstName:  String = ""
    var lastName:   String = ""
    var latitude:   String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //var longitude:  String = ""
    var mediaURL:   String = ""
    var createdAt:  String = ""
    var updatedAt:  String = ""
    var mapString:  String = ""
    var objectId:   String = ""
    var uniqueKey:  String = ""
    
    init?(data: [String:AnyObject])  {
        
        guard data["firstName"] != nil else {
            return nil
        }
        
        guard data["lastName"] != nil else {
            return nil
        }
        
        guard data["latitude"] != nil else {
            return nil
        }
        
        guard data["longitude"] != nil else {
            return nil
        }
        
        guard data["mediaURL"] != nil else {
            return nil
        }
        
        self.init(data)
    }
    
    init(_ data: [String:AnyObject]) {
        
        if let firstName = data["firstName"] {
            self.firstName = firstName as! String
        }
        
        if let lastName = data["lastName"] {
            self.lastName = lastName as! String
        }
        
        if let mediaURL = data["mediaURL"] {
            self.mediaURL = mediaURL as! String
        }
        
        if let latitude  = data["latitude"], let longitude = data["longitude"]
        {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        }
        
    }

    
}


class Utils {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    class func shared() -> Utils {
        struct Singleton {
            static var sharedInstance = Utils()
        }
        return Singleton.sharedInstance
    }
    
    func showActivityIndicator(show: Bool, parent:UIView) {
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        
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
    
}

func showAlert (message: String, parent: UIViewController) {
    
    let alert = UIAlertController.init(title: AppModel.appName, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: AppModel.titleAction, style: .default, handler: nil)
    alert.addAction(alertAction)
    parent.present(alert, animated: true, completion: nil)
    
}


