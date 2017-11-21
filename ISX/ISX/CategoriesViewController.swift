//
//  CategoriesViewController.swift
//  ISX
//
//  Created by Robby Michels on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class CategoriesViewController: UIViewController, UICollectionViewDelegate,
        UICollectionViewDataSource {
    
    private let viewName = "Categories Overview"
    var selectedCategory: Category?
    var categoryArray = [Category]()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        
        getFirebaseData()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
            as? CategoryCell else {
                return UICollectionViewCell()
        }
        
        cell.setCategoryData(category: categoryArray[indexPath.row])
        return cell
    }
    
    public func getFirebaseData(){
        let datarootRef = Database.database().reference(withPath: "dataroot")
        let productGroupsRef = datarootRef.child("productGroups")
        productGroupsRef.keepSynced(true)
        productGroupsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let category = Category(snapshot: value)
                    self.categoryArray.append(category)
                }
            }
            self.categoryCollectionView.reloadData()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
        GoogleAnalyticsHelper().googleAnalyticLogAction(category: viewName, action: "Choosing a Category", label: categoryArray[indexPath.row].categoryName)
        performSegue(withIdentifier: "productsDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "productsDetailSegue" {
            if let nextViewController = segue.destination as? ProductsViewController {
                if let category = self.selectedCategory {
                    nextViewController.category = category
                }
            }
        }
    }
}
