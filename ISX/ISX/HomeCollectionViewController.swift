////
////  HomeCollectionViewController.swift
////  ISX
////
////  Created by Maren Osnabrug on 18-10-17.
////  Copyright © 2017 Maren Osnabrug. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FirebaseDatabase
//
//class HomeCollectionViewController: UICollectionViewController {
//    
//    var datarootRef: DatabaseReference?
//    var productsRef: DatabaseReference?
//    
//    var productsArray = [Product]()
//    let imageArray = ["seiko", "airbus", "aigber", "bvlgari"]
//    var suggestionProductsArray = [Product]()
//    var selectedProduct: Product?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        
//        configureDatabase()
//    }
//    
//    func configureDatabase() {
//        datarootRef = Database.database().reference(withPath: "dataroot")
//        productsRef = datarootRef?.child("products")
//        productsRef?.observe(.value, with: { snapshot in
//            for (_, item) in snapshot.children.enumerated() {
//                if let product = item as? DataSnapshot {
//                    let modelProduct = Product.init(snapshot: product)
//                    self.productsArray.append(modelProduct)
//                    self.suggestionProductsArray = Array(self.productsArray.prefix(4))
//                }
//            }
//            self.collectionView?.reloadData()
//        })
//    }
//    
//    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return suggestionProductsArray.count
//    }
//    
//    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionCell else { return UICollectionViewCell() }
//        cell.setupStyling()
//        cell.suggestionImage.image = UIImage(named: imageArray[indexPath.row % imageArray.count])
//        cell.suggestionLabel.text = suggestionProductsArray[indexPath.row].title
//        
//        return cell
//    }
//    
////    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
////        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
////    }
//    
////    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        selectedProduct = suggestionProductsArray[indexPath.row]
////        performSegue(withIdentifier: "homeToProductSegue", sender: self)
////    }
////
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if (segue.identifier == "homeToProductSegue") {
////            if let nextViewController = segue.destination as? ProductInfoController {
////                if let product = selectedProduct {
////                    nextViewController.product = product
////                }
////            }
////        }
////    }
//}

