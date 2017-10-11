//
//  ProductsViewController.swift
//  ISX
//
//  Created by Robby Michels on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ProductsViewController: UIViewController, UICollectionViewDelegate,
 UICollectionViewDataSource {
    
    
    var rootRef: DatabaseReference!
    var categoryImages = ["sieraden", "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen"]
    var categories = [String]()
    var categoryID = [String]()
    var initialLoad = true;
    var chosenCategoryID: String?
    var chosenCategoryTitle: String?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //top bar kleur aanpassingen
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        navBar.barTintColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        //einde kleur aanpassingen
        
        firebaseData()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self

    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
            as! CustomCategoryCell
    
        cell.backgroundColor =  UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        
        cell.categoryCellImage.image = UIImage(named: categoryImages[indexPath.row % categoryImages.count])
        
        cell.categoryCellText.text = categories[indexPath.row]
        cell.categoryCellText.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        cell.categoryCellText.textColor = UIColor.white
        cell.categoryID = categoryID[indexPath.row]

        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    public func firebaseData(){
        let datarootRef = Database.database().reference(withPath: "dataroot")
        let productGroupsRef = datarootRef.child("productGroups")
        productGroupsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let value = (item as! DataSnapshot).value as? [String:Any]
                if let name = value!["Product_groep"] as? String {
                    self.categories.append(name)
                }
                
                if let categoryId = value!["ID"] as? String {
                    self.categoryID.append(categoryId)
                }
            }
            
            if (self.initialLoad == true) {
                self.categoryCollectionView.reloadData()
                self.initialLoad = false
            }
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.categoryCollectionView!.cellForItem(at: indexPath) as! CustomCategoryCell
        chosenCategoryID = cell.categoryID!
        self.chosenCategoryTitle = cell.categoryCellText!.text
        performSegue(withIdentifier: "productsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "productsDetail" {
            if let controller = segue.destination as? ProductsFromCategoriesController {
                if let catID = self.chosenCategoryID {
                    controller.categoryID = catID
                }
                if let catTitle = self.chosenCategoryTitle {
                    controller.navigationBarTitle = catTitle
                }
            }
        }
    }
}
