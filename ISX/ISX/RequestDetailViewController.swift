//
//  RequestInfoController.swift
//  ISX
//
//  Created by Robby Michels on 21-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class RequestDetailViewController: UITableViewController {
    private var datarootRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    private var favoritesRef: DatabaseReference?
    let numberOfCells = 6
    var productID: String?
    var chairNumber: String?
    var productDetail: Product?
    var usersDeviceID: String!
    var requestReference: DatabaseReference?
    var listWithUserFavorites = [Favorite]()
    var listWithFavorites = [Favorite]()
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Request details"
        tableView.delegate = self
        tableView.dataSource = self
        
        setupReference()
    }
    
    //Retrieve the product details from the DB.
    func getProductfromDB() {
        productsRef?.queryOrdered(byChild: "sku").queryEqual(toValue: productID).observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    self.productDetail = Product(snapshot: product)
                }
            }
            self.getFavoritesFromDB()
        })
    }
    
    //Retrieve all favorites from that user, from the DB.
    func getFavoritesFromDB() {
        listWithFavorites = []
        favoritesRef?.child(usersDeviceID).observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let favoriteFromFB = item as? DataSnapshot {
                    let favorite = Favorite(snapshot: favoriteFromFB)
                    self.listWithFavorites.append(favorite)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    //Setting up primary references, and starting to retrieve the products.
    func setupReference() {
        //We might be able to have this in Constants. func getProductsRef() -> DatabaseReference {
        datarootRef = Database.database().reference(withPath: Constants.firebaseDataroot)
        productsRef = datarootRef?.child(Constants.firebaseProductsTable)
        productsRef?.keepSynced(Constants.keepFirebaseSynced)
        favoritesRef = datarootRef?.child(Constants.firebaseFavoriteTable)
        favoritesRef?.keepSynced(Constants.keepFirebaseSynced)

        getProductfromDB()
    }

    //Return the number of rows that have to be created
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(productDetail != nil) {
            return (numberOfCells + listWithFavorites.count)
        }else {
            return 0
        }
    }
    
    //Give each individual cell a custom cellHeight.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return Constants.requestSimpleProductCellSize
        }else if(indexPath.row == 1) {
            return Constants.requestLabelCellSize
        }else if(indexPath.row == 2) {
            return Constants.requestLocationCellSize
        }else if(indexPath.row == 3) {
            return Constants.requestLabelCellSize
        }else if(indexPath.row >= 4 && indexPath.row <= (4 + (listWithFavorites.count - 1))) {
            return Constants.requestFavoriteCellSize
        }else if(indexPath.row == (numberOfCells + (listWithFavorites.count - 1))) {
            return Constants.requestExtraProductInfoCellSize
        }else {
            return Constants.requestLabelCellSize
        }
    }
    
    //Create each of the different cells, based on indexPath.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestProductInfo, for: indexPath) as? RequestProductInfoCell {
                //Check later if all this data can be stored in one object.
                cell.setCellData(productName: (self.productDetail?.title)!, usersChairNumber: chairNumber!, productNumber: (self.productDetail?.prologisticaNumberHH)!, productReference: self.requestReference!, isActive: self.request!.completed)
                return cell
            }
        }else if(indexPath.row == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestLocationLabelCell, for: indexPath) as? RequestLocationLabelCell {
                return cell
            }
        }else if(indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestLocationInfoCell, for: indexPath) as? RequestLocationInfoCell {
                cell.setCellData(product: productDetail!)
                return cell
            }
        }else if(indexPath.row == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestFavoritesLabelCell, for: indexPath) as? RequestFavoritesLabelCell {
                return cell
            }
        }else if(indexPath.row >= 4 && indexPath.row < ((numberOfCells + (listWithFavorites.count) - 2))) {
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.favoritesInRequestCell, for: indexPath) as? FavoritesInRequestCell {
                    //indexPath.row - 4, because when we reach this cell, the index is already at 4, otherwise the array from favorites goes out of bounds.
                    cell.setProductName(productName: listWithFavorites[(indexPath.row - 4)].title)
                    return cell
                }
        }else if(indexPath.row == ((numberOfCells + listWithFavorites.count) - 1) ) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestExtraProductDetailCell, for: indexPath) as? RequestExtraProductDetailCell {
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.requestExtraProductLabelCell, for: indexPath) as? RequestExtraProductDetailLabelCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Use this to navigate to the favorite detail page.
    }
}
