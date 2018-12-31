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
