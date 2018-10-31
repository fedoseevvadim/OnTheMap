//
//  SecondViewController.swift
//  On_the_map
//
//  Created by Vadim on 22/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = AppModel.appName

    }
    
    @IBAction func refreshAction(_ sender: Any) {
        print ("refreshAction")
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        print ("Logout")
    }
}

