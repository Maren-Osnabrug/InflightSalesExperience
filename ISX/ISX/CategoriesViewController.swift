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
import Google

class CategoriesViewController: UIViewController, UICollectionViewDelegate,
        UICollectionViewDataSource {
    
    let screenName = "Categories Overview"
    var categoryImages = ["sieraden", "parfum", "elektronica", "reizen", "sieraden",
                          "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen"]
    var selectedCategoryID: String?
    var categoryArray = [Category]()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let googleAnalyticsTracker = GAI.sharedInstance().defaultTracker else { return }
        googleAnalyticsTracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        googleAnalyticsTracker.send(builder.build() as NSDictionary as [NSObject : AnyObject])
        
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
        selectedCategoryID = categoryArray[indexPath.row].categoryID
        performSegue(withIdentifier: "productsDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "productsDetailSegue" {
            if let nextViewController = segue.destination as? ProductsViewController {
                if let catID = self.selectedCategoryID {
                    nextViewController.categoryID = catID
                }
            }
        }
    }
}
