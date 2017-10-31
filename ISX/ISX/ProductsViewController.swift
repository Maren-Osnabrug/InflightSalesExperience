//
//  ProductsViewController.swift
//  ISX
//
//  Created by Robby Michels on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    enum sortableProperties: String {
        
        case sortRelevant = "Relevance"
        case sortTitle = "Title (A-Z)"
        case sortPrice = "Price (Low-High)"
 
        func getDisplayText() -> String {
            return Constants.sortBy + rawValue
        }
        
    }

    var productsArray: [Product] = []
    var productImageArray = ["drank", "elektronica", "kinderen",
    "parfum", "reizen", "sieraden"]
    var categoryID: String?
    var selectedProduct: Product?
    var counter = 0
    
    //this has to be replaced by an algorithm at some point.
    var relevantArray: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.onClickSortLabel))
        sortLabel.addGestureRecognizer(tap)
        sortLabel.text = Constants.sortBy + sortableProperties.sortRelevant.rawValue
    
        title = "Products"
        
        getProducts(categoryId: categoryID!)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if (productsArray.count < 1) {
            setLabelOnEmptyCollectionView(emptyArray: true)
        } else {
            return productsArray.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        setLabelOnEmptyCollectionView(emptyArray: false)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath)
            as? ProductCell {
            cell.setCellData(product: productsArray[indexPath.row], image: productsArray[indexPath.row].image!)
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func getProducts(categoryId: String) {
        let rootRef = Database.database().reference(withPath: "dataroot")
        let productRef = rootRef.child("products")
        
        productRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let product = Product(snapshot: value)
                    product.setProductImage(productImage: UIImage(named: self.productImageArray[Int(arc4random_uniform(UInt32(self.productImageArray.count)))])!)
                    if product.productGroup.elementsEqual(categoryId) {
                        self.productsArray.append(product)
                    }
                }
            }
            self.collectionView.reloadData()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = productsArray[indexPath.row]
        performSegue(withIdentifier: "productInfoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productInfoSegue" {
            if let nextViewController = segue.destination as? ProductInfoController {
                if let product = selectedProduct {
                    nextViewController.product = product
                }
            }
        }
    }
    
    func sortFor(property: sortableProperties) {
        var toReturn = [Product]()
        if (property == sortableProperties.sortTitle) {
            relevantArray = productsArray
            toReturn = productsArray.sorted(by: { $0.title < $1.title })
        } else if (property == sortableProperties.sortPrice) {
            toReturn = productsArray.sorted(by: { $0.retailPrice < $1.retailPrice } )
        }
        
        productsArray = toReturn
        sortLabel.text = property.getDisplayText()
        collectionView.reloadData()
    }
    
    @objc func onClickSortLabel() {
        if (counter == 0) {
            counter += 1
            sortFor(property: sortableProperties.sortTitle)
        }else if (counter == 1) {
            counter += 1
            sortFor(property: sortableProperties.sortPrice)
        }else {
            counter = 0
            self.productsArray = self.relevantArray
            self.sortLabel.text = "Sorteer op: " + sortableProperties.sortRelevant.rawValue
            self.collectionView.reloadData()
        }
    }

    
    func setLabelOnEmptyCollectionView(emptyArray: Bool) {
        let emptyLabel = getNoProductsLabel()
        
        if emptyArray {
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    func getNoProductsLabel() -> UILabel {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        emptyLabel.text = "Unfortunately there were no products found in this category. Please choose one of our other categories"
        emptyLabel.textColor = UIColor(red:0.81, green:0.83, blue:0.82, alpha:1.0)
        emptyLabel.numberOfLines = 3
        emptyLabel.textAlignment = NSTextAlignment.center
        return emptyLabel
    }
}
