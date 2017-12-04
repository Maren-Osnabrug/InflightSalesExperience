////
////  ProductInfoCell.swift
////  ISX
////
////  Created by Rosyl Budike on 28-11-17.
////  Copyright © 2017 Maren Osnabrug. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FirebaseDatabase
//
//class ProductInfoCell: UITableViewCell {
//
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var milesLabel: UILabel!
//    @IBOutlet weak var arButton: UIButton!
//    @IBOutlet weak var favoriteButton: UIButton!
//    
//    var product: Product?
//    private var datarootRef: DatabaseReference?
//    private var favoriteRef: DatabaseReference?
//
//    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
//    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setupStyling()
////        setupReferences()
////    }
////    override func viewDidAppear(_ animated: Bool) {
////        observeFavoriteStatus()
////    }
//    
//    func setupData(product: Product) {
//        priceLabel.text = "€" + String(product.retailPrice)
//        milesLabel.text = "M" + String(product.retailPrice)
//    }
//    
//    func setupStyling(){
//        guard let product = product else {
//            return
//        }
//        favoriteButton.tintColor = Constants.orange
//        updateFavoriteButton(favorite: product.favorite)
//    }
//    
//    func setupReferences() {
//        datarootRef = Database.database().reference(withPath: "dataroot")
//        favoriteRef = datarootRef?.child("favorite")
//    }
//    
//    func observeFavoriteStatus() {
//        if let productID = product?.id {
//            favoriteRef?.child(Constants.DEVICEID).child(productID)
//                .observeSingleEvent(of: .value, with: { snapshot in
//                    if snapshot.hasChildren() {
//                        self.product?.changeFavoriteStatus()
//                        self.updateFavoriteButton(favorite: true)
//                    }else {
//                        self.product?.changeFavoriteStatus()
//                        self.updateFavoriteButton(favorite: false)
//                    }
//                })
//        }
//    }
//    
//    @IBAction func didClickFavoriteButton(_ sender: Any) {
//        if let product = product {
//            product.changeFavoriteStatus()
//            updateFavoriteButton(favorite: product.favorite)
//            
//            handleFavoriteInFirebase(isFavorite: product.favorite)
//            GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Favorite", action: "Favorite product", label: product.title)
//        }
//    }
//    
//    func updateFavoriteButton(favorite: Bool) {
//        if (favorite) {
//            favoriteButton.setImage(favoriteImage, for: .normal)
//        } else {
//            favoriteButton.setImage(unFavoriteImage, for: .normal)
//        }
//    }
//    
//    func handleFavoriteInFirebase(isFavorite: Bool) {
//        if let productID = product?.id {
//            if (isFavorite) {
//                if let favProduct = self.product {
//                    addFavoriteProduct(product: favProduct)
//                }
//            }else {
//                deleteFavorite(productID: productID)
//            }
//        }else {
//            return
//        }
//    }
//    
//    func addFavoriteProduct(product: Product) {
//        let pushObjectToFirebase = favoriteRef?.child(Constants.DEVICEID).child(product.id)
//        pushObjectToFirebase?.setValue(product.toAnyObject())
//    }
//    
//    func deleteFavorite(productID: String) {
//        favoriteRef?.child(Constants.DEVICEID).child(productID).removeValue()
//    }
//}

