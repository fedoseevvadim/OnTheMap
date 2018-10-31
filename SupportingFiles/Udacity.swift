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
    
    func logOut (completion: @escaping (_ error: String?) -> Void) {
        
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
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
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
