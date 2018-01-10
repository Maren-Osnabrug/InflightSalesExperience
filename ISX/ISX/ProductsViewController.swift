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
import NVActivityIndicatorView

class ProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    var category: Category?
    var selectedProduct: Product?
    var counter = 0
    private let viewName = "Product Overview"
    var activityIndicatorView: NVActivityIndicatorView?

    var relevantArray: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.onClickSortLabel))
        sortLabel.addGestureRecognizer(tap)
        sortLabel.text = Constants.sortBy + sortableProperties.sortRelevant.rawValue
    
        title = category?.categoryName
        
        getProducts(categoryId: (category?.categoryID)!)
        collectionView.delegate = self
        collectionView.dataSource = self
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: Constants.indicatorPadding)
        collectionView.addSubview(activityIndicatorView!)
    }
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        setLabelOnEmptyCollectionView(emptyArray: false)
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCell, for: indexPath)
            as? ProductCell {
            productCell.setCellData(product: productsArray[indexPath.row])
            return productCell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
    }
    
    public func getProducts(categoryId: String) {
        let productRef = Constants.getProductRef()
        productRef.keepSynced(Constants.isFirebaseSynced())
        activityIndicatorView?.startAnimating()
        productRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let product = Product(snapshot: value)
                    if product.productGroup.elementsEqual(categoryId) {
                        self.productsArray.append(product)
                    }
                }
            }
            self.collectionView.reloadData()
            self.activityIndicatorView?.stopAnimating()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = productsArray[indexPath.row]
        performSegue(withIdentifier: Constants.categoryToProductInfo, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.categoryToProductInfo) {
            if let nextViewController = segue.destination as? ProductInfoController {
                if let product = selectedProduct {
                    nextViewController.product = product
                    GoogleAnalyticsHelper().googleAnalyticLogAction(category: viewName, action: "Look at product", label: product.title)
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
        } else if (counter == 1) {
            counter += 1
            sortFor(property: sortableProperties.sortPrice)
        } else {
            counter = 0
            productsArray = self.relevantArray
            sortLabel.text = Constants.sortBy + sortableProperties.sortRelevant.rawValue
            collectionView.reloadData()
        }
    }

    
    func setLabelOnEmptyCollectionView(emptyArray: Bool) {
        let emptyLabel = getNoProductsLabel()
        if (emptyArray) {
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    func getNoProductsLabel() -> UILabel {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        emptyLabel.text = Constants.nothingHere
        emptyLabel.textColor = Constants.darkGrey
        emptyLabel.numberOfLines = 3
        emptyLabel.textAlignment = NSTextAlignment.center
        return emptyLabel
    }
}
