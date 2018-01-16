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
import NVActivityIndicatorView

class RequestDetailViewController: UITableViewController {
    private var datarootRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    private var favoritesRef: DatabaseReference?
    final let NUMBEROFCELLS = 6
    var requestDetail: RequestDetail?
    var productDetail: Product?
    var selectedFavorite: Favorite?
    var arrayWithUserFavorites = [Favorite]()
    var arrayWithFavorites = [Favorite]()
    var activityIndicatorView: NVActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Request details"
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: Constants.indicatorPadding)
        tableView.addSubview(activityIndicatorView!)
        setupReferences()
    }
    
    // Retrieve the product details from the DB.
    func getProductfromFirebase() {
        activityIndicatorView?.startAnimating()
        productsRef?.queryOrdered(byChild: "sku").queryEqual(toValue: requestDetail?.productId).observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    self.productDetail = Product(snapshot: product)
                }
            }
            self.getFavoritesFromFirebase()
        })
    }
    
    // Retrieve all favorites from that user, from the DB.
    func getFavoritesFromFirebase() {
        favoritesRef?.child((requestDetail?.deviceId)!).observe(.value, with: { snapshot in
            self.arrayWithFavorites = []
            for item in snapshot.children {
                if let favoriteFromFB = item as? DataSnapshot {
                    let favorite = Favorite(snapshot: favoriteFromFB)
                    self.arrayWithFavorites.append(favorite)
                }
            }
            self.activityIndicatorView?.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    // Setting up primary references, and starting to retrieve the products.
    func setupReferences() {
        productsRef = Constants.getProductRef()
        productsRef?.keepSynced(Constants.isFirebaseSynced())
        favoritesRef = Constants.getFavoriteRef()
        favoritesRef?.keepSynced(Constants.isFirebaseSynced())

        getProductfromFirebase()
    }

    // Return the number of rows that have to be created
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (productDetail != nil) {
            return (NUMBEROFCELLS + arrayWithFavorites.count)
        } else {
            return 0
        }
    }
    
    // Give each individual cell a custom cellHeight.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return Constants.requestProductCellSize
        } else if (indexPath.row == 1) {
            return Constants.requestLabelCellSize
        } else if (indexPath.row == 2) {
            return Constants.requestLocationCellSize
        } else if (indexPath.row == 3) {
            return Constants.requestLabelCellSize
        } else if (indexPath.row >= 4 && indexPath.row <= (4 + (arrayWithFavorites.count - 1))) {
            return Constants.requestFavoriteCellSize
        } else if (indexPath.row == (NUMBEROFCELLS + (arrayWithFavorites.count - 1))) {
            return Constants.requestExtraProductInfoCellSize
        } else {
            return Constants.requestLabelCellSize
        }
    }
    
    // Create each of the different cells, based on indexPath.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCrequestProductInfo, for: indexPath) as? ProductInfoCell {
                cell.setProductData(productName: (self.productDetail?.title)!, usersChairNumber: (requestDetail?.chairnumber)!, productNumber: (productDetail?.prologisticaNumberHH)!, productReference: (requestDetail?.requestDatabaseRef)!, isActive: (requestDetail?.request?.completed)!)
                return cell
            }
        } else if (indexPath.row == 1) {
            return tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationLabel, for: indexPath) as UITableViewCell
        } else if (indexPath.row == 2) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationInfo, for: indexPath) as? LocationInfoCell {
                cell.setProductData(product: productDetail!)
                return cell
            }
        } else if (indexPath.row == 3) {
            return tableView.dequeueReusableCell(withIdentifier: Constants.CCFavoritesLabel, for: indexPath) as UITableViewCell
        } else if (indexPath.row >= 4 && indexPath.row < ((NUMBEROFCELLS + (arrayWithFavorites.count) - 2))) {
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCfavoritesInfo, for: indexPath) as? CCFavoritesCell {
                    cell.setProductName(productName: arrayWithFavorites[(indexPath.row - 4)].title)
                    return cell
                }
        } else if (indexPath.row == ((NUMBEROFCELLS + arrayWithFavorites.count) - 1) ) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductDetail, for: indexPath) as? ProductDetailCell {
                return cell
            }
        } else {
            return tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductLabel, for: indexPath) as UITableViewCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFavorite = arrayWithFavorites[indexPath.row - 4]
        performSegue(withIdentifier: Constants.productDetailToRequestFavorite, sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.productDetailToRequestFavorite) {
            if let nextViewController = segue.destination as? RequestFavoritesViewController {
                nextViewController.favorite = selectedFavorite
                nextViewController.requestDetail = requestDetail
            }
        }
    }
    
}
