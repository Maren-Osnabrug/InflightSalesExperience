//
//  FavoritesViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FavoritesViewController: UITableViewController {
    
    var favoritesArray = [Product]()
    private var datarootRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupReference()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setupReference() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        productsRef = datarootRef?.child("products")
        productsRef?.keepSynced(true)
        observeProducts()
    }
    
    func observeProducts() {
//        productsRef?.observe(.value, with: { snapshot in
//            for item in snapshot.children {
//                let toAdd = Product.init(snapshot: item as! DataSnapshot)
//                if (toAdd.favorite) {
//                    self.favoritesArray.append(toAdd)
//                }
//            }
//            self.tableView.reloadData()
//        })
//
        productsRef?.queryOrdered(byChild: "favorite").queryStarting(atValue: true).observe(.value, with: { (snapshot) in
            self.favoritesArray = []
            for item in snapshot.children {
                let toAdd = Product.init(snapshot: item as! DataSnapshot)
                print(toAdd.title, toAdd.id)
                if (!self.favoritesArray.contains { $0.id == toAdd.id }) {
                   
                    self.favoritesArray.append(toAdd)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFavoritesCell", for: indexPath) as? FavoritesCell else { return UITableViewCell() }
        let favoriteForCell = favoritesArray[indexPath.row]
        cell.productName.text = favoriteForCell.title
        cell.productPrice.text = "€ " + favoriteForCell.retailPrice
        
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
            let favoriteProduct = self.favoritesArray[indexPath.row]
            favoriteProduct.changeFavoriteStatus()
            success(true)
        })
        modifyAction.image = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        modifyAction.backgroundColor = Constants.blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}
