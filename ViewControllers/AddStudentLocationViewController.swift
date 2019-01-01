//
//  AddStudentLocationViewController.swift
//  On_the_map
//
//  Created by Вадим Федосеев on 25.11.2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var StudentLocation: CLLocationCoordinate2D?
    var webText: String?
    var locationText: String?
    
    
    @IBAction func onClickFinish(_ sender: Any) {
        
        guard var current = StudentStruct.loggedInStudent else {
            return
        }

        current.mediaURL = webText ?? ""
        current.mapString = locationText ?? ""
        current.coordinate = StudentLocation!
        
        if !current.isPosted {
            
            UdacityClient.sharedInstance().postStudentData(current) { (result, error) in
                guard error == nil else {
                    
                    showAlert(message: error!, parent: self)
                    
                    return
                }
                guard let result = result else {
                    showAlert(message: AppModel.error.noResultsWhilePost, parent: self)
                    return
                }
                do {
                    let resultDict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: AnyObject]
                    current.objectId = resultDict["objectId"] as! String
                    current.isPosted = true
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    showAlert(message: AppModel.error.errorWhilePosting, parent: self)
                }
            }
        } 
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard StudentLocation != nil else {
            return
        }
        
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = StudentLocation!
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: StudentLocation!, latitudinalMeters: 200, longitudinalMeters: 200)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
        mapView.delegate = self as! MKMapViewDelegate
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        Utils.shared().showActivityIndicator(show: true, parent: view)
        
    }
    
}
