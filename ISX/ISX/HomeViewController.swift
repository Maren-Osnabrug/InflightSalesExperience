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
import NVActivityIndicatorView

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var productsRef: DatabaseReference?
    
    var suggestedProductsArray = [Product]()
    var bestSellersArray = [Product]()
    var selectedProduct: Product?
    var activityIndicatorView: NVActivityIndicatorView?
    private let viewName = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: Constants.indicatorPadding)
        collectionView?.addSubview(activityIndicatorView!)
        configureDatabase()
    }

    /*
     * For configuring the database ref and getting the bestsellers from the database
     */
    func configureDatabase() {
        productsRef = Constants.getProductRef()
        productsRef?.keepSynced(true)
        activityIndicatorView?.startAnimating()
        productsRef?.queryOrdered(byChild: "Bestsellers").queryStarting(atValue: "1").observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product(snapshot: product)
                    self.bestSellersArray.append(modelProduct)
                }
                self.shuffleSuggestions()
            }
            self.collectionView?.reloadData()
            self.activityIndicatorView?.stopAnimating()
        })
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedProductsArray.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let suggestionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.suggestionCell, for: indexPath) as? SuggestionCell
            else { return UICollectionViewCell() }

        suggestionCell.setupData(product: suggestedProductsArray[indexPath.row])
        return suggestionCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = suggestedProductsArray[indexPath.row]
        performSegue(withIdentifier: Constants.homeToProductInfo, sender: self)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.homeCollectionViewHeader, for: indexPath) as? HomeCollectionViewHeader else { return UICollectionReusableView() }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.homeToProductInfo) {
            if let nextViewController = segue.destination as? ProductInfoController {
                if let product = selectedProduct {
                    nextViewController.product = product
                    GoogleAnalyticsHelper().googleAnalyticLogAction(category: "suggestions", action: "Look at product", label: product.title)
                }
            }
        }
    }
    
    /*
     * For triggering the search functionality
     */
    func didTapSearch() {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: Constants.searchViewController)
        let navigationController = UINavigationController(rootViewController: searchViewController!)
        navigationController.setViewControllers([searchViewController!], animated: false)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        didTapSearch()
    }
    
    /*
     * For shuffling our recommended suggestions
     */
    func shuffleSuggestions() {
        bestSellersArray.shuffle()
        suggestedProductsArray = Array(bestSellersArray.prefix(Constants.suggestionCount))
        collectionView?.reloadData()
    }
}

/*
 * These extensions allow for shuffling of an array
 */

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
