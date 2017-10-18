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
    
    var categoryImages = ["sieraden", "parfum", "elektronica", "reizen", "sieraden",
                          "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen"]
    var selectedCategoryID: String?
    var categoryArray = [Category]()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFirebaseData()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
            as! CategoryCell
        
        cell.setCellData(category: categoryArray[indexPath.row])
        return cell
    }
    
    public func getFirebaseData(){
        let datarootRef = Database.database().reference(withPath: "dataroot")
        let productGroupsRef = datarootRef.child("productGroups")
        
        // rewrite with model
        productGroupsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let value = (item as! DataSnapshot).value as? [String:Any]
                if let name = value!["Product_groep"] as? String {
                    if let categoryId = value!["ID"] as? String {
                        let category = Category(categoryID: categoryId, categoryName: name,
                                                categoryImage: UIImage(named: self.categoryImages[Int(arc4random_uniform(UInt32(self.categoryImages.count)))])!)
                        self.categoryArray.append(category)
                    }
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
