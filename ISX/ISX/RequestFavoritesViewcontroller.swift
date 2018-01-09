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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Detail"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Return the number of rows that have to be created
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBEROFROWS
    }
    
    //Give each individual cell a custom cellHeight.
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
            return 0
        }
    }
    
    //Create each of the different cells, based on indexPath.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row) {
        case 0  :
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCrequestProductInfo, for: indexPath) as? ProductInfoCell {
                cell.setCellData(productName: (favorite?.title)!, productNumber: (favorite?.prologistricaNumberHH)!, isFavorite: true, favorite: favorite!, requestDetail: requestDetail!)
                return cell
            }
        case 1  :
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationLabel, for: indexPath) as? LocationLabelCell {
                return cell
            }
        case 2  :
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCLocationInfo, for: indexPath) as? LocationInfoCell {
                cell.setCellData(product: favorite!)
                return cell
            }
        case 3  :
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductLabel, for: indexPath) as? ProductDetailLabelCell {
                return cell
            }
        case 4  :
            if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCExtraProductDetail, for: indexPath) as? ProductDetailCell {
                return cell
            }
        default : /* Optional */
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
}
