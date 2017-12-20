//
//  Constants.swift
//  ISX
//
//  Created by Rosyl Budike on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
//      PRAGMA MARK: Colors
    static let grey = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
    static let blue = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
    static let orange = UIColor(red:0.89, green:0.45, blue:0.13, alpha:1.0)
    static let darkGrey = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
    static let textGrey = UIColor(red:0.81, green:0.83, blue:0.82, alpha:1.0)
    static let okayGreen = UIColor(red:0.50, green:0.86, blue:0.15, alpha:1.0)
    static let spinnerGrey = UIColor.black.withAlphaComponent(0.25)
    static let radiusBorderColor = UIColor.clear.cgColor
    static let radiusShadowColor = UIColor.lightGray.cgColor
    
    static let buttonCornerRadius:CGFloat = 10
    static let chairNumberViewCornerRadius:CGFloat = 15
    
    //PRAGMA MARK: Borders
    static let cellBorderWidth: CGFloat = 1
    static let shadowOpacity: Float = 0.8
    static let shadowRadius: CGFloat = 3
    static let shadowOffset = CGSize(width: 1, height: 1)

//      PRAGMA MARK: Display strings
    static let sortBy = "Sort by: "
    
//      PRAGMA MARK: Spacing
    static let sectionInsetsCollectionView: CGFloat = 60
    static let dividingFactorCollectionViewCell: CGFloat = 2
    static let multiplierFactorCollectionViewCell: CGFloat = 1.3
    static let multiplierFactorSuggestionHeader: CGFloat = 0.40
    static let indicatorPadding:CGFloat = 150
    
//      PRAGMA MARK: Random
    static let suggestionCount = 4
    static let chairNumberRegex = "^\\d{1,2}[A-Za-z]{1}$"
    static let DEVICEID = UIDevice.current.identifierForVendor!.uuidString
    static let imageViewFrame = CGRect(x: 0, y: 0, width: 400, height: 400)

//      PRAGMA MARK: Segues
    static let productInfoToWeb = "productInfoToWebSegue"
    static let productInfoToAR = "productInfoToARSegue"
    static let homeToProductInfo = "homeToProductInfoSegue"
    static let cabincrewToProductDetail = "toRequestInfoSegue"
    
//      PRAGMA MARK: Row heights
    static let tableViewRowHeight:CGFloat = 85

//      PRAGMA MARK: Cells
    static let progressBarCellHeight:CGFloat = 100
    static let requestCellHeight:CGFloat = 130
    static let requestSimpleProductCellSize: CGFloat = 155
    static let requestLabelCellSize: CGFloat = 30
    static let requestLocationCellSize: CGFloat = 155
    static let requestFavoriteCellSize: CGFloat = 50
    static let requestExtraProductInfoCellSize: CGFloat = 400
    static let searchBarCellHeight:CGFloat = 60

    //PRAGMA MARK: firebase
    static let firebaseFavoriteTable = "favorite"
    static let firebaseDataroot = "dataroot"
    static let firebaseProductsTable = "products"
    static let firebaseFlightsTable = "flights"
    static let firebaseProductGroupsTable = "productGroups"
    static let firebaseRequestsTable = "requests"
    static let keepFirebaseSynced = true

    
//      PRAGMA MARK: Calculate miles
    static let multiplierFactorMiles = 400
    
    //PRAGMA MARK: Buttons
    static let popupButtonHeight = 60
    
    //PRAGMA MARK: Reusable identifiers
    static let progressbarCell = "progressCell"
    static let customRequestCell = "CustomRequestCell"
    static let requestProductInfo = "requestProductInfoCell"
    static let requestLocationLabelCell = "requestLocationLabelCell"
    static let requestLocationInfoCell = "requestLocationInfoCell"
    static let requestFavoritesLabelCell = "requestFavoritesLabelCell"
    static let favoritesInRequestCell = "favoritesInRequestCell"
    static let requestExtraProductDetailCell = "requestExtraProductDetailCell"
    static let requestExtraProductLabelCell = "requestExtraProductLabelCell"
}
