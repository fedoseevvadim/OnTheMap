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
    static let XParseApplication                = "X-Parse-Application-Id"
    static let XParseREST                       = "X-Parse-REST-API-Key"
    static let userOrPassIncorrect              = "Username or password is incorrect"
    
    
    struct udacity {
        
        static let apiPathSession   = "https://onthemap-api.udacity.com/v1/session"
        static let apiPathUsers     = "https://onthemap-api.udacity.com/v1/users/"
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
    
    struct error {
        static let errorPost                        = "Error while posting student"
        static let errorPostData                    = "Could not post student data"
        static let errorCode                        = "Post student request returned a status code other than 2xx!"
        static let noResultsWhilePost               = "No results while posting data"
        static let errorWhilePosting                = "Error while parsing post result"
        static let errorWithRequest                 = "Error with the request"
        static let resultIsNil                      = "Result is nil from Udacity"
        static let jsonSerializationFailed          = "Json serialization failed"
        static let jsonSerializationFailedStudent   = "Json serialization failed while getting student detail info"
        static let userIdIsMissing                  = "User ID missing during login"
        static let accountIDisMissing               = "Account is missing in login"
        static let errorReturnStudentDetails        = "Error returned from Student details"
    }
    
}

// example of JSON data
// ["latitude": 37.386052, "createdAt": 2018-10-31T13:55:31.328Z, "longitude": -122.083851, "firstName": John, "mediaURL": https://udacity.com, "updatedAt": 2018-10-31T13:55:31.328Z, "mapString": Mountain View, CA, "lastName": Doe, "objectId": 8HKXdPJ5Ia, "uniqueKey": 1234]

class StudentStruct {
    static var students: [StudentInformation]?
    static var loggedInStudent: StudentInformation?
}

struct StudentInformation {
    
    var userId:     String = ""
    var firstName:  String = ""
    var lastName:   String = ""
    var latitude:   String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var longitude:  String = ""
    var mediaURL:   String = ""
    var createdAt:  String = ""
    var updatedAt:  String = ""
    var mapString:  String = ""
    var objectId:   String = ""
    var uniqueKey:  String = ""
    var isPosted: Bool = false
    
    init?(fromData: [String:AnyObject])  {

        guard fromData["firstName"] != nil else {
            return nil
        }

        guard fromData["lastName"] != nil else {
            return nil
        }

        guard fromData["latitude"] != nil else {
            return nil
        }

        guard fromData["longitude"] != nil else {
            return nil
        }

        guard fromData["mediaURL"] != nil else {
            return nil
        }

        self.init(fromData)
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
        
        if let latitude  = data["latitude"], let longitude = data["longitude"] {
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


