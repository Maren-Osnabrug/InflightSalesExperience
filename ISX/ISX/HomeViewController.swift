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

extension UIView {
    func addBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionProductsCollectionView: UICollectionView!
    
    var datarootRef: DatabaseReference?
    var productsRef: DatabaseReference?
    
    
    var productsArray = [Product]()
    var suggestionProductsArray = [Product]()
    var selectedProduct: Product?
    private let viewName = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        suggestionProductsCollectionView.delegate = self
        suggestionProductsCollectionView.dataSource = self
        
        configureDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        suggestionLabel.addBottomBorder(color: Constants.grey, width: 1)
    }
    
    func configureDatabase() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        productsRef = datarootRef?.child("products")
        productsRef?.observe(.value, with: { snapshot in
            for (_, item) in snapshot.children.enumerated() {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product.init(snapshot: product)
                    self.productsArray.append(modelProduct)
                    self.suggestionProductsArray = Array(self.productsArray.prefix(4))
                }
            }
            self.suggestionProductsCollectionView.reloadData()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionProductsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionCell else { return UICollectionViewCell() }
        cell.setupStyling()
        cell.suggestionImage.image = UIImage(named: productsArray[indexPath.row].id)
        if ((UIImage(named: productsArray[indexPath.row].id)) == nil){
            cell.suggestionImage.image = UIImage(named: "noImageAvailable")
        }
        cell.suggestionLabel.text = suggestionProductsArray[indexPath.row].title

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = suggestionProductsArray[indexPath.row]
        performSegue(withIdentifier: "homeToProductSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "homeToProductSegue") {
            if let nextViewController = segue.destination as? ProductInfoController {
                if let product = selectedProduct {
                    nextViewController.product = product
                    GoogleAnalyticsHelper().googleAnalyticLogAction(category: "suggestions", action: "Look at product", label: product.title)
                }
            }
        }
    }
}
