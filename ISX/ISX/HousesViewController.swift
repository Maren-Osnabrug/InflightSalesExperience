//
//  HousesViewController.swift
//  ISX
//
//  Created by Rosyl Budike on 13-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView

class HousesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var housesCollectionView: UICollectionView!
    
    var housesArray: [Product] = []
    var category: Category?
    var selectedHouse: Product?
    
    var activityIndicatorView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = category?.categoryName        
        getHouses(categoryId: (category?.categoryID)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return housesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "houseCell", for: indexPath) as? HouseCell
            else { return UICollectionViewCell() }
        cell.setCellData(product: housesArray[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 3
        return CGSize(width: itemSize, height: itemSize*1.4)
    }
    
    public func getHouses(categoryId: String) {
        let rootRef = Database.database().reference(withPath: "dataroot")
        let houseRef = rootRef.child("products")
        houseRef.keepSynced(true)
        activityIndicatorView?.startAnimating()
        houseRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let house = Product(snapshot: value)
                    if house.productGroup.elementsEqual(categoryId) {
                        self.housesArray.append(house)
                    }
                }
            }
            self.housesCollectionView.reloadData()
            self.activityIndicatorView?.stopAnimating()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedHouse = housesArray[indexPath.row]
        performSegue(withIdentifier: "houseInfo", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "houseInfo" {
            if let nextViewController = segue.destination as? HouseInfoViewController {
                if let house = selectedHouse {
                    nextViewController.house = house
                }
            }
        }
    }
}
