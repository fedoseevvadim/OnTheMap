//
//  DetailViewController.swift
//  On_the_map
//
//  Created by Vadim on 30/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = AppModel.appName
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
