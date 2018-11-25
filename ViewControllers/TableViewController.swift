//
//  TableViewController.swift
//  On_the_map
//
//  Created by Vadim on 22/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = AppModel.appName

        self.loadData()
        
    }
    
    func loadData () {
        
        UdacityClient.sharedInstance().getStudentsLocation() { ( error ) in
            
            guard error == nil else {
                showAlert(message: "Error", parent: self)
                return
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: Button actions
    
    @IBAction func refreshAction(_ sender: Any) {
        self.loadData()
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
    
    //MARK: TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let students = StudentInformation.students else {
            return 0
        }
        
        return students.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        
        guard let students = StudentInformation.students else {
            return cell
        }
        
        let student = students[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
        
    }
}

