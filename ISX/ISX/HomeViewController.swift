//
//  HomeViewController.swift
//  ISX
//
//  Created by Rosyl Budike on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

// Border bottom code
extension UIView {
    func addBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    
//    var productsArray = [Product]()
    var datarootRef : DatabaseReference?
    var productsRef: DatabaseReference?
    
    var productsArray = [Product]()
    let imageArray = ["seiko", "airbus", "aigber", "bvlgari"]
    var textArray = [String]()
    var suggestionProductsArray = [Product]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.tabBarController?.tabBar.unselectedItemTintColor = Constants.blue
        self.tabBarController?.tabBar.layer.borderWidth = 1
        self.tabBarController?.tabBar.layer.borderColor = Constants.grey.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        
        self.datarootRef = Database.database().reference(withPath: "dataroot")
        self.productsRef = datarootRef?.child("products")
        configureDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        suggestionLabel.addBottomBorder(color: Constants.grey, width: 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureDatabase() {
        self.productsRef?.observe(.value, with: { snapshot in
            for (_, item) in snapshot.children.enumerated() {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product.init(snapshot: product)
                    print(modelProduct.title)
                    self.productsArray.append(modelProduct)
                    self.suggestionProductsArray = Array(self.productsArray.prefix(4))
                }
            }
                self.suggestionCollectionView.reloadData()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionProductsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomSuggestionProductsCell
        
        customCell.suggestionProductImage.image = UIImage(named: imageArray[indexPath.row % imageArray.count])
        customCell.suggestionProductLabel.text = suggestionProductsArray[indexPath.row].title
        
        customCell.backgroundColor = Constants.grey
        customCell.suggestionProductTextContainer.backgroundColor = Constants.blue
        return customCell
    }
}
