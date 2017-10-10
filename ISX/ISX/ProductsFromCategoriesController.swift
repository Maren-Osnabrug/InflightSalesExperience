//
//  ProductsFromCategoriesController.swift
//  ISX
//
//  Created by Robby Michels on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

class ProductsFromCategoriesController: UIViewController,
                UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationBar!
    var productArray = [Product]()
    var productImageArray = ["drank", "elektronica", "kinderen",
    "parfum", "reizen", "sieraden"]
    var initialLoad = true
    var categoryID: String?
    var boolean = true
    let dataRoot = "dataroot"
    let products = "products"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        statusBar.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        navBar.barTintColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        getProducts(categoryId: self.categoryID!)
    }
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomProductCell", for: indexPath)
            as! CustomProductCell
        
        cell.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        
        cell.productCellImage.image = UIImage(named: productImageArray[indexPath.row % productImageArray.count])
        cell.productCellTitle.text = productArray[indexPath.row].title
        cell.productCellPrice.text = "€" + productArray[indexPath.row].retailPrice
        
        return cell
    }
    
    public func getProducts(categoryId: String) {
        let rootRef = Database.database().reference(withPath: dataRoot)
        let productRef = rootRef.child(products)
        
        productRef.observe(.value, with: { snapshot in
            for (_, item) in snapshot.children.enumerated() {
                if let value = item as? DataSnapshot {
                    let product = Product.init(snapshot: value)
                    if product.productGroup.elementsEqual(categoryId) {
                        self.productArray.append(product)
                    }
                }
            }
            self.reloadData()
        })
    }
    func reloadData(){
        if (self.initialLoad == true && self.collectionView != nil) {
            self.collectionView.reloadData()
            self.initialLoad = false
        }
    }
}
