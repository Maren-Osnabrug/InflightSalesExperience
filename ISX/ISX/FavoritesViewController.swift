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
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFavoritesCell", for: indexPath) as? FavoritesCell else { return UITableViewCell() }

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
        let modifyAction = UIContextualAction(style: .normal, title:  "Unfavorite", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Unfavorite action ...")
            success(true)
        })
        modifyAction.image = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        modifyAction.backgroundColor = Constants.blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
