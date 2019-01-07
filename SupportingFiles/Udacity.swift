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
    
    func getStudentData(_ userId: String, completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        
        var studentApiPath = AppModel.udacity.apiPathUsers
        studentApiPath.append(userId)
        let request = URLRequest(url: URL(string: studentApiPath)!)
        let studentTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, "Error with the student request: \(error?.localizedDescription ?? " ")")
                return
            }
            
//            guard let status = (response as? HTTPURLResponse)?.statusCode,
//                status >= 200 && status <= 299 else {
//                    completion(nil, "Student Request status code is bad")
//                    return
//            }
            
            guard let data = data else {
                completion(nil, "Student Request returned no data")
                return
            }
            
            let range = (5..<data.count)
            let subData = data.subdata(in: range)
            completion(subData, nil)
   
        }
        
        studentTask.resume()
        
    }
    
    func getStudentsLocation (completion: @escaping (_ error: String?) ->Void) {
        
        var urlString: String = AppModel.udacityStudentLocation
        urlString.append("?limit=100&order=-updatedAt")
        
        var request = URLRequest(url: URL(string: AppModel.udacityStudentLocation)!)
        request.addValue(AppModel.udacityAppID, forHTTPHeaderField: AppModel.XParseApplication)
        request.addValue(AppModel.udacityAPIKey, forHTTPHeaderField: AppModel.XParseREST)
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
                    
                    StudentStruct.students = [StudentInformation]()
                    
                    for student in studentsDict {
                        if let studentStruct = StudentInformation (fromData: student) {
                            StudentStruct.students?.append(studentStruct)
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
    
    func postStudentData(_ current: StudentInformation, completionHandler: @escaping (_ result: Data?, _ error: String? )->Void) {
        
        var request = URLRequest(url: URL(string: AppModel.udacityStudentLocation)!)
        
        request.httpMethod = "POST"
        request.addValue(AppModel.udacityAPIKey, forHTTPHeaderField: AppModel.XParseREST)
        request.addValue(AppModel.udacityAppID, forHTTPHeaderField: AppModel.XParseApplication)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        var dict = [String : AnyObject] ()
        dict["userId"]      = current.userId                as AnyObject
        dict["lastName"]    = current.lastName              as AnyObject
        dict["firstName"]   = current.firstName             as AnyObject
        dict["mediaURL"]    = current.mediaURL              as AnyObject
        dict["latitude"]    = current.coordinate.latitude   as AnyObject
        dict["longitude"]   = current.coordinate.longitude  as AnyObject
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {}

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(nil, AppModel.error.errorPost)
                return
            }
            
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                completionHandler(nil, AppModel.error.errorCode)
//                return
//            }
            
            guard let data = data else
            {
                completionHandler(nil, AppModel.error.errorPostData)
                return
            }

            completionHandler(data,nil)
        }
        
        task.resume()
    }
    
    
    func logOut (completion: @escaping (_ result: Data?, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: AppModel.udacity.apiPathSession)!)
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
        
        let request             = NSMutableURLRequest(url: URL(string: AppModel.udacity.apiPathSession)!)
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
                status != 403 else {
                completion(nil, AppModel.userOrPassIncorrect)
                return
            }
            
            guard status >= 200 && status <= 299 else {
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
