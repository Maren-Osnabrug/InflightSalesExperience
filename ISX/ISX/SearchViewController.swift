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
    var tableViewController = UITableViewController()
    var filteredProductsArray = [Product]()
    var product = [Product]()
    var selectedProduct: Product?
    var datarootRef : DatabaseReference?
    var productsRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.tableView.dataSource = self
        tableViewController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: self.tableViewController)
        searchController.searchResultsUpdater = self
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        styling()
        configureDatabase()
    }
    
    /*
     Styling for page
    */
    func styling() {
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.backgroundColor = Constants.blue
        navigationController?.navigationBar.barTintColor = Constants.blue
    }
    
    /*
     Database setup
     */
    func configureDatabase() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        productsRef = Constants.getProductRef()
        
        productsRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product(snapshot: product)
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
        filteredProductsArray = product.filter({ (product: Product) -> Bool in
            if product.title.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            }else {
                return false
            }
        })
        tableViewController.tableView.reloadData()
    }
    
    /*
     Return array with search results
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProductsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.searchBarCellHeight
    }
    
    /*
     Add search results from array to cell in tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchCell = Bundle.main.loadNibNamed("searchCell", owner: self, options: nil)?.first as? SearchCell
        else { return UITableViewCell() }
        let product = filteredProductsArray[indexPath.row]
        searchCell.setSearchCell(product: product)
        return searchCell
    }
    
    /*
     Get selected product
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = filteredProductsArray[indexPath.row]
        performSegue(withIdentifier: Constants.searchToProductInfo, sender: self)
    }
    
    /*
     Prepare for searchToProductInfoSegue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == Constants.searchToProductInfo {
            if let nextViewController = segue.destination as? ProductInfoController {
                if (selectedProduct != nil) {
                    nextViewController.product = selectedProduct
                }
            }
        }
    }
}

