//
//  RequestFavoritesViewcontroller.swift
//  ISX-CabinCrew
//
//  Created by Robby Michels on 21-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class RequestFavoritesViewController: UITableViewController {
    var favorite: Favorite?
    var requestDetail: RequestDetail?
    final let NUMBEROFROWS = 5
    final let SWITCHDEFAULT: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Detail"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Return the number of rows that have to be created
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBEROFROWS
    }
    
    // Give each individual cell a custom cellHeight.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
        case 0  :
            return Constants.requestProductCellSize
        case 1  :
            return Constants.requestLabelCellSize
        case 2  :
            return Constants.requestLocationCellSize
        case 3  :
            return Constants.requestLabelCellSize
        case 4  :
            return Constants.requestExtraProductInfoCellSize
        default :
            return SWITCHDEFAULT
        }
    }
    
    // Create each of the different cells, based on indexPath.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCrequestProductInfo, for: indexPath) as? ProductInfoCell {
                    cell.setFavoriteData(productName: (favorite?.title)!, productNumber: (favorite?.prologistricaNumberHH)!, isFavorite: true, favorite: favorite!, requestDetail: requestDetail!)
                    return cell
                }
            case 1:
                return tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationLabel, for: indexPath) as UITableViewCell
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationInfo, for: indexPath) as? LocationInfoCell {
                    cell.setFavoriteData(product: favorite!)
                    return cell
                }
            case 3:
                return tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductLabel, for: indexPath) as UITableViewCell
            case 4:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductDetail, for: indexPath) as? ProductDetailCell {
                    return cell
                }
            default:
                return UITableViewCell()
            }
        return UITableViewCell()
    }
    
}
