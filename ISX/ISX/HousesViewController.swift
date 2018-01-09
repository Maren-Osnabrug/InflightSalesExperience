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
    
    var housesArray: [House] = []
    var category: Category?
    var selectedHouse: House?
    
    var activityIndicatorView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = category?.categoryName        
        getHouses(categoryId: (category?.categoryID)!)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return housesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "houseCell", for: indexPath) as? HouseCell
            else { return UICollectionViewCell() }
        cell.setCellData(house: housesArray[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + Constants.sectionInsetsCollectionView)) / Constants.dividingFactorCollectionViewCell
        return CGSize(width: itemSize, height: itemSize*Constants.multiplierFactorHousesCollectionViewCell)
    }
    
    public func getHouses(categoryId: String) {
        let rootRef = Database.database().reference(withPath: "dataroot")
        let houseRef = rootRef.child("houses")
        houseRef.keepSynced(true)
        activityIndicatorView?.startAnimating()
        houseRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let value = item as? DataSnapshot {
                    let house = House(snapshot: value)
                    if house.category.elementsEqual(categoryId) {
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
        performSegue(withIdentifier: Constants.houseToInfo, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.houseToInfo {
            if let nextViewController = segue.destination as? HouseInfoViewController {
                if let house = selectedHouse {
                    nextViewController.house = house
                }
            }
        }
    }
}
