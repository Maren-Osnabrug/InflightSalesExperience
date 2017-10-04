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
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    
    var isDoneLoading = false;
    
    var productsArray = [Product]()
    var datarootRef : DatabaseReference?
    var productsRef: DatabaseReference?
    
    // Array with suggestion products
    let imageArray = ["seiko", "airbus", "aigber", "bvlgari"]
    var textArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Statusbar blue
//        UIApplication.shared.statusBarStyle = .lightContent
//        UINavigationBar.appearance().clipsToBounds = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        self.setNeedsStatusBarAppearanceUpdate()
    
        // Border bottom for "Onze suggesties" label
        // suggestionLabel.layer.borderWidth = 1.0
        // suggestionLabel.layer.borderColor = UIColor.gray.cgColor
        suggestionLabel.addBottomBorderWithColor(color: UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0), width: 1)
        
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        
        // Tabbar items unselected color
        UITabBar.appearance().unselectedItemTintColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        // Tabbar border top
        self.tabBarController?.tabBar.layer.borderWidth = 1
        self.tabBarController?.tabBar.layer.borderColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        
        self.datarootRef = Database.database().reference(withPath: "dataroot")
        self.productsRef = datarootRef?.child("products")
        configureDatabase()
            
        
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
                    self.textArray.append(modelProduct.title)
//                    self.productsArray.append(modelProduct)
                }
            }
            if(!self.isDoneLoading) {
                self.suggestionCollectionView.reloadData()
                self.isDoneLoading = true
            }
        })
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomSuggestionProductsCell
        
        customCell.suggestionImage.image = UIImage(named: imageArray[indexPath.row % imageArray.count])
        customCell.suggestionText.text = textArray[indexPath.row % textArray.count]
        
        customCell.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        customCell.suggestionViewText.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        return customCell
    }
}
