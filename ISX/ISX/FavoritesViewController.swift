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
    
    private var favoritesArray = [Product]()
    private var productIDArray = [String]()
    private var datarootRef: DatabaseReference?
    private var favoriteRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    var selectedProduct: Product?
    private let viewName = "Favorite view"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        
        setupReference()

        tableView.dataSource = self
        tableView.reloadData()
        setupReference()
    }
    
    func setupReference() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        favoriteRef = datarootRef?.child("favorite")
        productsRef = datarootRef?.child("products")
        productsRef?.keepSynced(true)
        observeFavorites()
    }
    
    func observeFavorites() {
        favoriteRef?.child(Constants.DEVICEID).observe(.value, with: { snapshot in
            for item in snapshot.children {
                guard let item = item as? DataSnapshot else { continue }
                if let data = item.value as? [String: AnyObject] {
                    if let productID = data["productid"] as? String {
                        self.productIDArray.append(productID)
                    }
                }
            }
            self.observeProducts()
        })
    }
    
    func observeProducts() {
        self.favoritesArray = []
        print("#@@#@#@!@##@!@#!@!#@#!@!#@!#")
        productsRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                guard let item = item as? DataSnapshot else { continue }
                if let data = item.value as? [String: AnyObject] {
                    if let productid = data["sku"] as? String {
                        for productidFromArray in self.productIDArray {
                            if(productidFromArray.elementsEqual(productid)) {
                                let toAdd = Product(snapshot: item)
                                self.favoritesArray.append(toAdd)
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        
//        productsRef?.queryOrdered(byChild: "favorite").queryStarting(atValue: true).observe(.value, with: {
//            snapshot in
//            self.favoritesArray = []
//            for item in snapshot.children {
//                guard let item = item as? DataSnapshot else { continue }
//
//                let toAdd = Product(snapshot: item)
//                if (!self.favoritesArray.contains { $0.id == toAdd.id }) {
//                    self.favoritesArray.append(toAdd)
//                }
//            }
//            self.tableView.reloadData()
//        })
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
        
        let favorite = favoritesArray[indexPath.row]
        cell.updateWithFavorite(favorite: favorite)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = favoritesArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "favoriteToProductSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToProductSegue" {
            if let controller = segue.destination as? ProductInfoController {
                if let product = selectedProduct {
                    controller.product = product
                    GoogleAnalyticsHelper().googleAnalyticLogAction(category: viewName, action: "Look at product", label: product.title)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title: "Unfavorite", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let favoriteProduct = self.favoritesArray[indexPath.row]
            self.deleteFavorite(productID: favoriteProduct.id)
            success(true)
        })
        modifyAction.image = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        modifyAction.backgroundColor = Constants.orange
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func deleteFavorite(productID: String) {
        datarootRef?.child("favorite").child(Constants.DEVICEID).child(productID).removeValue()
    }
}
