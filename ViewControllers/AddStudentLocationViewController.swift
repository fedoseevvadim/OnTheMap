//
//  AddStudentLocationViewController.swift
//  On_the_map
//
//  Created by Вадим Федосеев on 25.11.2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit
import MapKit

class AddStudentLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationOfStudent: CLLocationCoordinate2D?
    var webText: String?
    var locationText: String?
    //var studentID: Int?
    
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        navigationItem.title = AppModel.appName
        
        super.viewDidLoad()
        
        guard locationOfStudent != nil else {
            return
        }
        
        if let mapView = self.mapView {
        
            let annotation = MKPointAnnotation.init()
            annotation.coordinate = locationOfStudent!
            mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: locationOfStudent!, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let adjustedRegion = mapView.regionThatFits(region)
            mapView.setRegion(adjustedRegion, animated: true)
            
            mapView.delegate = self

        }
    }
    
    
    @IBAction func onClickFinish(_ sender: Any) {
        
        guard var current = StudentStruct.loggedInStudent else {
            return
        }

        current.mediaURL = webText ?? ""
        current.mapString = locationText ?? ""
        current.coordinate = locationOfStudent!
        
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
                
                //do {
                    //let resultDict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: AnyObject]
                    //current.objectId = resultDict["objectId"] as! String
                
                current.objectId = (StudentStruct.loggedInStudent?.objectId)!
                current.isPosted = true

                
                //let mapViewController = MapViewController()
                //self.navigationController?.pushViewController(mapViewController, animated: true)
                    //self.dismiss(animated: true, completion: nil)
                //} catch {
                //    showAlert(message: AppModel.error.errorWhilePosting, parent: self)
                //}
            }
        }
        
        //dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Utils.shared().showActivityIndicator(show: true, parent: view)
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        //Utils.shared().showActivityIndicator(show: false, parent: self.view)
    }
    
}
