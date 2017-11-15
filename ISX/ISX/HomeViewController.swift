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

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var datarootRef: DatabaseReference?
    var productsRef: DatabaseReference?
    
    var suggestedProductsArray = [Product]()
    var bestSellersArray = [Product]()
    var bestSellers = ["40780", "45118", "45411", "15129", "15128", "10110", "11808", "10048", "10109", "10053", "68112"]
    var selectedProduct: Product?
    private let viewName = "Home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        configureDatabase()
    }

    func configureDatabase() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        productsRef = datarootRef?.child("products")
        productsRef?.queryOrdered(byChild: "Bestsellers").queryStarting(atValue: "1").observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    let modelProduct = Product(snapshot: product)
                    self.bestSellersArray.append(modelProduct)
                }
                self.shuffleSuggestions()
            }
            self.collectionView?.reloadData()
        })
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedProductsArray.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionCell
            else { return UICollectionViewCell() }

        cell.setupData(product: suggestedProductsArray[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorCollectionViewCell)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = suggestedProductsArray[indexPath.row]
        performSegue(withIdentifier: "homeToProductSegue", sender: self)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeCollectionViewHeader", for: indexPath) as? HomeCollectionViewHeader else { return UICollectionReusableView() }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
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
    
    func didTapSearch() {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "searchViewController")
        let navigationController = UINavigationController(rootViewController: searchViewController!)
        navigationController.setViewControllers([searchViewController!], animated: false)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        didTapSearch()
    }
    
    func shuffleSuggestions() {
        bestSellersArray.shuffle()
        suggestedProductsArray = Array(bestSellersArray.prefix(Constants.suggestionCount))
        collectionView?.reloadData()
    }
}

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
