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
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    private var productsRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupReferences()
        observeRequests()
        tableView.dataSource = self
    }
    
    func setupReferences() {
        Database.database().isPersistenceEnabled = true
        datarootRef = Database.database().reference(withPath: "dataroot")
        requestsRef = datarootRef?.child("requests")
        productsRef = datarootRef?.child("products")
        
        requestsRef?.keepSynced(true)
    }
    
    func observeRequests() {
        requestsRef?.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            for item in snapshot.children {
                let toAdd = Request.init(snapshot: item as! DataSnapshot)
                if (!self.requestsArray.contains { $0.id == toAdd.id }) {
                    self.requestsArray.append(toAdd)
                    self.requestsArray.sort { !$0.completed && $1.completed }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomRequestCell", for: indexPath) as? RequestCell else { return UITableViewCell() }
        cell.setupStyling()
        
        let requestForCell = requestsArray[indexPath.row]
        
        productsRef?.observe(.value, with: { snapshot in
            let arr = snapshot.children.allObjects as NSArray
            for item in arr {
                let item = Product.init(snapshot: item as! DataSnapshot)
                if item.id == String(requestForCell.productId) {
                    cell.productName.text = item.title
                }
            }
        })
        
        cell.contentView.layer.opacity = requestForCell.completed ? 0.25 : 1
        cell.productCode.text = String(requestForCell.productId)
        cell.chairLabel.text = String(requestForCell.customerChair)

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
