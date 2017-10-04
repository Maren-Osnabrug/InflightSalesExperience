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
    var categories = ["sieraden", "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen"]
    var testArray = [String]()
    var initialLoad = true;
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        navBar.barTintColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        firebaseData()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self

    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.testArray.count)
        return self.testArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
            as! CustomCategoryCell
        cell.backgroundColor =  UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        
        cell.categoryCellImage.image = UIImage(named: categories[indexPath.row % categories.count])
        
        
        cell.categoryCellText.text = testArray[indexPath.row]
        cell.categoryCellText.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        cell.categoryCellText.textColor = UIColor.white
    
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
                    print(name)
                    self.testArray.append(name)
                }
            }
            print("Aantal objecten in array: ", self.testArray.count)
            if (self.initialLoad == true) {
                self.categoryCollectionView.reloadData()
                self.initialLoad = false
            }
        })
    }
}
