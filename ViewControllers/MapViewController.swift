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

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        navigationItem.title = AppModel.appName
        
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
        
        Utils.shared().showActivityIndicator(show: true, parent: self.view)
        enableButtons(false)
        UdacityClient.sharedInstance().getStudentsLocation() { (error) in
            
            guard error == nil else {
                showAlert(message: "Error", parent: self)
                return
            }
            self.addPin()
            Utils.shared().showActivityIndicator(show: false, parent: self.view)
            self.enableButtons(true)
            
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UdacityClient.sharedInstance().logOut() { (data, error) in
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK - mapView functions
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        Utils.shared().showActivityIndicator(show: true, parent: self.view)
        //self.enableButtons(false)
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        Utils.shared().showActivityIndicator(show: false, parent: self.view)
        self.enableButtons(true)
        
    }

//    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//
//        //Utils.shared().showActivityIndicator(show: false, parent: self.vie)
//        //self.enableButtons(true)
//
//    }
    
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        
        Utils.shared().showActivityIndicator(show: true, parent: self.view)
        self.enableButtons(false)
        
        UdacityClient.sharedInstance().getStudentsLocation() { ( error ) in

            guard error == nil else {
                showAlert(message: "Error", parent: self)
                return
            }

            self.addPin()
            //Utils.shared().showActivityIndicator(show: false, parent: self.view)
            //self.enableButtons(true)
        }

    }
    
    func addPin () {
        
        guard let students = StudentInformation.students else {
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.title = student.firstName + " " + student.lastName
            annotation.coordinate = student.coordinate
            annotation.subtitle = student.mediaURL
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        
    }
    
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
        
    }

    func enableButtons (_ enable: Bool) {
        
        //mapView.alpha = CGFloat(0.2)
        mapView.isOpaque = enable
        addButton.isEnabled = enable
        refreshButton.isEnabled = enable
        logoutButton.isEnabled = enable
        
    }

    
}
