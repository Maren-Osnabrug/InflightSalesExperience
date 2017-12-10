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
    var listWithUserFavorites = [Favorite]()
    //var listWithFavorites = [String]()
    var listWithFavorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Request details"
        setupReference()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        favoritesTableView.frame = CGRect(x: favoritesTableView.frame.origin.x, y: favoritesTableView.frame.origin.y, width: favoritesTableView.frame.size.width, height: favoritesTableView.contentSize.height)
//    }
//
//    override func viewDidLayoutSubviews(){
//        favoritesTableView.frame = CGRect(x: favoritesTableView.frame.origin.x, y: favoritesTableView.frame.origin.y, width: favoritesTableView.frame.size.width, height: favoritesTableView.contentSize.height)
//        favoritesTableView.reloadData()
//    }
    
    func getProductfromFirebase() {
        //query doesnt work
        print("@@@@@@@@@@@@@@@@@@@@@@@@@ ______  ", productID, " _____@@@@@@@@@@@@@@@@@@@")
        productsRef?.queryOrdered(byChild: "sku").queryEqual(toValue: productID).observe(.value, with: { snapshot in
            for item in snapshot.children {
                print(snapshot)
                if let product = item as? DataSnapshot {
                    self.productDetail = Product(snapshot: product)
                    print(product)
                }
                //self.setRequestedProductDetails()
            }
            self.getFavoritesFromFirebase()
        })
    }
    
    func getFavoritesFromFirebase() {
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
    
    func setupReference() {
        datarootRef = Database.database().reference(withPath: Constants.firebaseDataroot)
        productsRef = datarootRef?.child(Constants.firebaseProductsTable)
        productsRef?.keepSynced(Constants.keepFirebaseSynced)
        favoritesRef = datarootRef?.child(Constants.firebaseFavoriteTable)
        favoritesRef?.keepSynced(Constants.keepFirebaseSynced)
        //setupStyling()
        getProductfromFirebase()
//        getFavoritesFromUser()
    }
    
//    func setRequestedProductDetails() {
//        guard let pName = productDetail?.title else { return }
//        guard let pCode = productDetail?.id else { return }
//        productName.text = pName
//        productCode.text = pCode
//        userChairnumber.text = chairNumber
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //5 custom cells atm.
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        if(productDetail != nil) {
            print("returning 5")
            return (numberOfCells + listWithFavorites.count)
        }else {
            return 0
        }
    }
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestProductInfoCell", for: indexPath) as? RequestProductInfoCell {
                cell.setCellData(productName: (self.productDetail?.title)!, usersChairNumber: chairNumber!, productNumber: (self.productDetail?.prologisticaNumberHH)!)
                return cell
            }
        }else if(indexPath.row == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestLocationLabelCell", for: indexPath) as? RequestLocationLabelCell {
                return cell
            }
        }else if(indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestLocationInfoCell", for: indexPath) as? RequestLocationInfoCell {
                cell.setCellData(product: productDetail!)
                return cell
            }
        }else if(indexPath.row == 3) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestFavoritesLabelCell", for: indexPath) as? RequestFavoritesLabelCell {
                return cell
            }
        }else if(indexPath.row >= 4 && indexPath.row < ((numberOfCells + (listWithFavorites.count) - 2))) {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesInRequestCell", for: indexPath) as? FavoritesInRequestCell {
                    cell.setProductName(productName: listWithFavorites[(indexPath.row - 4)].title)
                    return cell
            }
        }else if(indexPath.row == ((numberOfCells + listWithFavorites.count) - 1) ) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestExtraProductDetailCell", for: indexPath) as? RequestExtraProductDetailCell {
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "requestExtraProductLabelCell", for: indexPath) as? RequestExtraProductDetailLabelCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
