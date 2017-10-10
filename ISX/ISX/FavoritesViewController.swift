//
//  FavoritesViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.reloadData()
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFavoritesCell", for: indexPath) as! FavoritesCell

        cell.productName.text = String("Expensive thing")
        cell.productPrice.text = String("€1000")
        
        cell.cellContentView.layer.borderColor = UIColor.white.cgColor
        cell.cellContentView.layer.borderWidth = 1

        cell.productImage.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let editAction = UITableViewRowAction(style: .normal, title: "♡\n Unfavorite") { (rowAction, indexPath) in
//            //TODO: edit the row at indexPath here
//        }
//        editAction.backgroundColor = UIColor.init(red:0.05, green:0.65, blue:0.88, alpha:1.0)
//
//        return [editAction]
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print(indexPath.row)
//        }
//    }
}
