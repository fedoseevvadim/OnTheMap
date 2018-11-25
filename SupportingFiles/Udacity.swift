//
//  Udacity.swift
//  On_the_map
//
//  Created by Вадим Федосеев on 25.10.2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation

class UdacityClient {
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func getStudentsLocation (completion: @escaping (_ error: String?) ->Void) {
        
        var request = URLRequest(url: URL(string: AppModel.udacityStudentLocation)!)
        request.addValue(AppModel.udacityAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(AppModel.udacityAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completion("Get students server error: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(AppModel.errorUnknownErrorWithStudentLoc)
                return
            }
            
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                if let studentsDict = dict["results"] as? [[String:AnyObject]] {
                    
                    StudentInformation.students = [studentStruct]()
                    
                    for student in studentsDict {
                        if let studentStruct = studentStruct (data: student) {
                            StudentInformation.students?.append(studentStruct)
                        }
  
                    }
                    
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                completion(AppModel.errorWithGetStudentsData)
            }
            
        }
        task.resume()
        
    }
    
    func logOut (completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: AppModel.udacity.apiPath)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(nil, AppModel.errorWithLogOut + ": \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode,
                status >= 200 && status <= 299 else {
                    completion(nil, AppModel.errorWithLogOutRequest)
                    return
            }
            
            guard let data = data else {
                completion(nil, "Logout request returned no data")
                return
            }
            
            completion(data, nil)
        }
        
        task.resume()
        
    }
    
    func login (email: String, password: String, completion: @escaping (_ result: Data?, _ error: String?) -> Void ) {
        
        let request             = NSMutableURLRequest(url: URL(string: AppModel.udacity.apiPath)!)
        let fieldsDictionary    = NSMutableDictionary()
        let udacityDictionary   = NSMutableDictionary()
        
        request.httpMethod  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        fieldsDictionary.setValue(email,    forKey: AppModel.udacity.username)
        fieldsDictionary.setValue(password, forKey: AppModel.udacity.password)
        
        udacityDictionary.setValue(fieldsDictionary, forKey: AppModel.udacity.udacity)
        
        do {

            let requestData = try JSONSerialization.data(withJSONObject: udacityDictionary, options: .prettyPrinted)
            request.httpBody = requestData

        } catch {

            completion(nil, "Error")
            return

        }
        
        let urlTask = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            guard error == nil else {
                completion(nil, AppModel.errorWithLogin + ": \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode,
                status >= 200 && status <= 299 else {
                    completion(nil, AppModel.loginStatus)
                    return
            }
            
            guard let data = data else {
                completion(nil, AppModel.noData)
                return
            }
            
            completion(data, nil)
        }
        
        urlTask.resume()
      
    }
    
    
}
