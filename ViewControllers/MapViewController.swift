//
//  MapViewController.swift
//  On_the_map
//
//  Created by Vadim on 30/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        
        
        navigationItem.title = AppModel.appName
        UdacityClient.sharedInstance().getStudentsLocation() { ( error ) in
            
//            guard error == nil else {
//                // alert
//                return
//            }
            
            //mapView.removeAnnotation()
            
        }
        
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        //print("Log out")
        
        UdacityClient.sharedInstance().logOut() { (data, error) in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
}
