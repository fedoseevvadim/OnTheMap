//
//  TableViewController.swift
//  On_the_map
//
//  Created by Vadim on 22/10/2018.
//  Copyright © 2018 Vadim. All rights reserved.
//

import Foundation
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

        guard let students = StudentStruct.students else {

            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            
            tableView.separatorStyle = .none
            //tableView.backgroundView?.isHidden = true
            tableView.backgroundView? = noDataLabel
            return 0
        }
        
        return students.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        
//        if cell == nil {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StudentCell")
//        }
        
        guard let students = StudentStruct.students else {
            return cell
        }
        
        let student = students[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        print(student)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let students = StudentStruct.students else {
            return
        }
        
        let mediaUrl = students[indexPath.row].mediaURL
        
        guard let url = URL(string: mediaUrl) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showAlert(message: "URL cannot be opened", parent: self)
        }
        
    }
}

