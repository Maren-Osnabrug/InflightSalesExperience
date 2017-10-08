//
//  CabinCrewViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class CabinCrewViewController: UITableViewController {
    
    var requestsArray = [Request]()
    var datarootRef: DatabaseReference?
    var requestsRef: DatabaseReference?
    var productsRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Database.database().isPersistenceEnabled = true
        self.datarootRef = Database.database().reference(withPath: "dataroot")
        self.requestsRef = datarootRef?.child("requests")
        self.productsRef = datarootRef?.child("products")
        
        self.requestsRef?.keepSynced(true)
        tableView.dataSource = self
        
        self.requestsRef?.queryOrdered(byChild: "completed").observeSingleEvent(of: .value, with: { snapshot in
            for item in snapshot.children {
                self.requestsArray.append(
                    Request.init(snapshot: item as! DataSnapshot)
                )
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRequestCell", for: indexPath) as! RequestCell
        let requestForCell = self.requestsArray[indexPath.row]
        
        self.productsRef?.observe(.value, with: { snapshot in
            let arr = snapshot.children.allObjects as NSArray
            for item in arr {
                let item = Product.init(snapshot: item as! DataSnapshot)
                if item.id == String(requestForCell.productId) {
                    print("Found: ", item.title)
                    cell.productName.text = item.title
                }
            }
        })
        
        cell.contentView.layer.opacity = requestForCell.completed ? 0.25 : 1
        
//        cell.productName.text = "completed: " + String(requestForCell.completed)
        cell.productCode.text = String(requestForCell.productId)
        
        cell.cellContentView.layer.borderColor = UIColor.white.cgColor
        cell.cellContentView.layer.borderWidth = 1
        
        cell.chairView.layer.cornerRadius = 15
        cell.chairView.layer.borderColor = UIColor.clear.cgColor
        cell.chairView.layer.borderWidth = 1
        cell.chairView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.chairView.layer.shadowOpacity = 0.8
        cell.chairView.layer.shadowRadius = 3
        cell.chairView.layer.shadowOffset = CGSize.init(width: 1, height: 1)
        
        cell.chairLabel.text = String(requestForCell.customerChair)
        cell.productImage.backgroundColor = UIColor.lightGray

        return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Mark as Done", message: "Have you delivered this product to the passenger in seat \(self.requestsArray[indexPath.row].customerChair)?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
            self.requestsArray[indexPath.row].completed = true
            self.requestsArray.sort { !$0.completed && $1.completed }
            self.requestsArray[indexPath.row].ref?.updateChildValues([
                "completed": true
                ])
            self.tableView.cellForRow(at: indexPath)?.contentView.layer.opacity = 0.25
            self.tableView.reloadData()
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
            self.requestsArray[indexPath.row].completed = false
            self.requestsArray.sort { !$0.completed && $1.completed }
            self.requestsArray[indexPath.row].ref?.updateChildValues([
                "completed": false
                ])
            self.tableView.cellForRow(at: indexPath)?.contentView.layer.opacity = 1
            self.tableView.reloadData()
        })
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
