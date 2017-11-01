//
//  SearchViewController.swift
//  ISX
//
//  Created by Jasper Zwiers on  17-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    var searchController = UISearchController(searchResultsController: nil)
    var resultsController = UITableViewController()
    var filteredProductsObjects = [Product]()
    var product = [Product]()
    var selectedProduct: Product?
    var datarootRef : DatabaseReference?
    var productsRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: self.resultsController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.backgroundColor = Constants.blue
        navigationController?.navigationBar.barTintColor = Constants.blue
        searchController.searchBar.delegate = self
        
        datarootRef = Database.database().reference(withPath: "dataroot")
        productsRef = datarootRef?.child("products")
        
        productsRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product.init(snapshot: product)
                    if (!self.product.contains { $0.id == modelProduct.id }) {
                        self.product.append(modelProduct)
                    }
                }
            }
        })
    }
    
    /*
     Exit search when cancel is clicked
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search cancel")
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
    /*
     Close view when background is clicked
     */
    @IBAction func userTappedBackground(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /*
     Update the search results
     */
    func updateSearchResults(for searchController: UISearchController) {
        filteredProductsObjects = product.filter({ (product: Product) -> Bool in
            if product.title.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            }else {
                return false
            }
        })
        self.resultsController.tableView.reloadData()
    }
    
    /*
     Return array with search results
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProductsObjects.count
    }
    
    /*
     Add search results from array to cell in tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredProductsObjects[indexPath.row].title
        return cell
    }
    
    /*
     Get selected product
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = filteredProductsObjects[indexPath.row]
        performSegue(withIdentifier: "searchToProductInfoSegue", sender: self)
    }
    
    /*
     Prepare for searchToProductInfoSegue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "searchToProductInfoSegue" {
            if let controller = segue.destination as? ProductInfoController {
                if (selectedProduct != nil) {
                    controller.product = selectedProduct
                }
            }
        }
    }
}

