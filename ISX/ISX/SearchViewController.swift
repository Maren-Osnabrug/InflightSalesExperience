//
//  SearchViewController.swift
//  ISX
//
//  Created by Jasper Zwiers on 17-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    var searchController = UISearchController(searchResultsController: nil)
    var resultsController = UITableViewController()
    var products = [String]()
    var filteredProducts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        searchController = UISearchController(searchResultsController: self.resultsController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        //Searchbar color
        searchController.searchBar.backgroundColor = Constants.blue
        searchController.searchBar.tintColor = Constants.grey
        
        //Txtfile > Array
        let path = Bundle.main.path(forResource: "product", ofType: "txt")
        let filemgr = FileManager.default
        if filemgr.fileExists(atPath: path!){
            do {
                let fullText = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                let readings = fullText.components(separatedBy: "\n")
                for i in 0..<readings.count {
                    products.append(readings[i])
                }
            } catch _ as NSError {
                print("Error")
            }
        }
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
        self.filteredProducts = self.products.filter { (product:String) -> Bool in
            if product.lowercased().contains(self.searchController.searchBar.text!.lowercased()) {
                return true
            } else {
                return false
            }
        }
        self.resultsController.tableView.reloadData()
    }
    
    /*
     Return array with search results
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    /*
     Add search results from array to cell in tableView
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.filteredProducts[indexPath.row]
        return cell
    }
}

