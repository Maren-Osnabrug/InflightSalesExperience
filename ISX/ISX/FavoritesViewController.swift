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
import NVActivityIndicatorView

class FavoritesViewController: UITableViewController {
    private var favoritesArray = [Product]()
    private var datarootRef: DatabaseReference?
    private var favoriteRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    var selectedProduct: Product?
    private let viewName = "Favorite view"
    var activityIndicatorView: NVActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
    
        tableView.dataSource = self
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: 150)
        tableView.addSubview(activityIndicatorView!)
        setupReference()
    }
    
    func setupReference() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        favoriteRef = datarootRef?.child("favorite")
        favoriteRef?.keepSynced(true)
        observeFavorites()
    }
    
    func observeFavorites() {
        activityIndicatorView?.startAnimating()
        favoriteRef?.child(Constants.DEVICEID).observe(.value, with: { snapshot in
            self.favoritesArray = []
            for item in snapshot.children {
                guard let item = item as? DataSnapshot else { continue }
                let product = Product(snapshot: item)
                self.favoritesArray.append(product)
            }
            self.tableView.reloadData()
            self.activityIndicatorView?.stopAnimating()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomFavoritesCell", for: indexPath) as? FavoritesCell else { return UITableViewCell() }
        
        if let favorite = favoritesArray[indexPath.row] as? Product {
            cell.updateWithFavorite(favorite: favorite)
        }
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
            self.deleteFavorite(productID: favoriteProduct.id, indexPath: indexPath)
            success(true)
        })
        modifyAction.image = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
        modifyAction.backgroundColor = Constants.orange
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func deleteFavorite(productID: String, indexPath: IndexPath) {
        datarootRef?.child("favorite").child(Constants.DEVICEID).child(productID).removeValue()
        favoritesArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
