//
//  CategoriesViewController.swift
//  ISX
//
//  Created by Robby Michels on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import NVActivityIndicatorView

class CategoriesViewController: UIViewController, UICollectionViewDelegate,
        UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let viewName = "Categories Overview"
    var selectedCategory: Category?
    var categoryArray = [Category]()
    var activityIndicatorView: NVActivityIndicatorView?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        
        getFirebaseData()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: 150)
        categoryCollectionView.addSubview(activityIndicatorView!)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.categoryCell, for: indexPath)
            as? CategoryCell else {
                return UICollectionViewCell()
        }
        
        categoryCell.setCategoryData(category: categoryArray[indexPath.row])
        return categoryCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
    }
    
    public func getFirebaseData(){
        let productGroupsRef = Constants.getProductGroupsRef()
        productGroupsRef.keepSynced(Constants.isFirebaseSynced())
        activityIndicatorView?.startAnimating()
        productGroupsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let category = Category(snapshot: value)
                    self.categoryArray.append(category)
                }
            }
            self.categoryCollectionView.reloadData()
            self.activityIndicatorView?.stopAnimating()
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
        GoogleAnalyticsHelper().googleAnalyticLogAction(category: viewName, action: "Choosing a Category", label: categoryArray[indexPath.row].categoryName)
        if (selectedCategory?.categoryID == Constants.housesCategoryID) {
            performSegue(withIdentifier: Constants.categoryToHouses, sender: self)
        } else {
            performSegue(withIdentifier: Constants.productToProductInfo, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == Constants.productToProductInfo) {
            if let nextViewController = segue.destination as? ProductsViewController {
                if let category = self.selectedCategory {
                    nextViewController.category = category
                }
            }
        } else if (segue.identifier == Constants.categoryToHouses) {
            if let nextViewController = segue.destination as? HousesViewController {
                if let category = self.selectedCategory {
                    nextViewController.category = category
                }
            }
        }
    }
}
