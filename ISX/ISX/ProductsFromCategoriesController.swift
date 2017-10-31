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
    var productArray = [Product]()
    var productImageArray = ["drank", "elektronica", "kinderen",
    "parfum", "reizen", "sieraden"]
    var initialLoad = true
    var categoryID: String?
    var navigationBarTitle: String?
    var chosenProduct: Product?
    var boolean = true
    let dataRoot = "dataroot"
    let products = "products"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        title = "Products"
        
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let cell = self.collectionView!.cellForItem(at: indexPath) as! CustomProductCell
    
        chosenProduct = productArray[indexPath.row]
        
        performSegue(withIdentifier: "productInfo", sender: self)
    }
    
    //navigationController?.popViewController(animated: true)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "productInfo" {
            if let controller = segue.destination as? ProductInfoController {
                if let product = self.chosenProduct {
                    controller.product = product
                }
            }
        }
    }
    
    
}
