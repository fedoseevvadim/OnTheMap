//
//  AddViewController.swift
//  On_the_map
//
//  Created by Vadim on 30/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit
import CoreLocation

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var buttonFinish: UIButton!
    
    var locationText: String?
    var webText: String?
    var studentLocation: CLLocationCoordinate2D?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = AppModel.appName
        locationTextField.delegate = self
        websiteTextField.delegate = self
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func clickOnFindLocation(_ sender: Any) {
        
        guard let url = websiteTextField.text, isValidUrl(url) else {
            showAlert(message: AppModel.EnterValidURL, parent: self)
            return
        }
        
        guard let location = locationTextField.text,
            location.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            showAlert(message: AppModel.EnterLocation, parent: self)
            return
        }
        
        
        //Utils.shared().showActivityIndicator(show: true, parent: self.view)
        let geo = CLGeocoder()
        geo.geocodeAddressString(location) { (addressString, error) in
            
            guard error == nil else {
                //Utils.shared().showActivityIndicator(show: false, parent: self.view)
                showAlert(message: "Error getting location information", parent: self)
                return
            }
            
            if let place = addressString, place.count > 0 {
                
                let placeLocation: CLLocation = (place.first?.location)!
                self.studentLocation = placeLocation.coordinate
                self.locationText = location
                self.webText = url
                //Utils.shared().showActivityIndicator(show: false, parent: self.view)
                self.performSegue(withIdentifier: "StudentCoordinate", sender: self)
                
            }
            
        }
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "StudentCoordinate" {

            let controller = segue.destination as! AddStudentLocationViewController
            controller.locationText = locationText
            controller.webText = webText
            controller.locationOfStudent = studentLocation
            //controller.studentID =
        }
    }
    
    func isValidUrl (_ urlString: String )->Bool {
        
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return predicate.evaluate(with: urlString)
        
    }
}
