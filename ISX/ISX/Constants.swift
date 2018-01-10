//
//  Constants.swift
//  ISX
//
//  Created by Rosyl Budike on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

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
    
//      PRAGMA MARK: Borders
    static let cellBorderWidth: CGFloat = 1
    static let shadowOpacity: Float = 0.8
    static let shadowRadius: CGFloat = 3
    static let shadowOffset = CGSize(width: 1, height: 1)

//      PRAGMA MARK: Display strings
    static let sortBy = "Sort by: "

//      PRAGMA MARK: Reuse Strings
    static let noImageAvailable: String = "noImageAvailable"
    static let drawerEurNorway: String = "Drawer Norway: "
    static let drawerEurExt: String = "Drawer Extended: "
    static let drawerEurReduced: String = "Drawer Reduced: "
    static let drawerIca: String = "Drawer ICA: "
    
//      PRAGMA MARK: Popup Strings
    struct Popup {
        static let productSoldTitle: String = "Product sold!"
        static let productSoldMsg: String = "Good Job! The sold items and sales amount will be updated. Keep up the good work!"
        static let errorTitle: String = "Oops, Something went wrong!"
        static let errorMsg: String = "Please try again later"
        static let understand: String = "I understand"
        static let orderTitle: String = "Inflight Sales Order"
        static let enterAccountDetails: String = "Please enter an email address and a password"
        static let wrongAccountDetails: String = "Incorrect email address or password"
    }
    
//      PRAGMA MARK: Spacing
    static let sectionInsetsCollectionView: CGFloat = 60
    static let dividingFactorCollectionViewCell: CGFloat = 2
    static let multiplierFactorCollectionViewCell: CGFloat = 1.3
    static let multiplierFactorSuggestionHeader: CGFloat = 0.40
    static let indicatorPadding:CGFloat = 150
    static let dividingFactorHousesCollectionViewCell: CGFloat = 3
    static let multiplierFactorHousesCollectionViewCell: CGFloat = 1.4
    
//      PRAGMA MARK: Random
    static let suggestionCount = 4
    static let chairNumberRegex = "^\\d{1,2}[A-Za-z]{1}$"
    static let DEVICEID = UIDevice.current.identifierForVendor!.uuidString
    static let imageViewFrame = CGRect(x: 0, y: 0, width: 400, height: 400)
    static let requestIsCompleted = true
    static let requestIsNotCompleted = false
    static let emptyString: String = ""

//      PRAGMA MARK: Segues
    static let loginToRequests = "loginSeque"
    static let productInfoToWeb = "productInfoToWebSegue"
    static let productInfoToAR = "productInfoToARSegue"
    static let homeToProductInfo = "homeToProductInfoSegue"
    static let categoryToHouses = "categoryToHousesSeque"
    static let houseToHouseInfo = "houseToInfoSeque"
    static let cabincrewToProductDetail = "cabincrewToRequestInfoSegue"
    static let productDetailToRequestFavorite = "requestdetailToRequestFavorites"
    static let productToProductInfo = "productsDetailSegue"
    static let searchToProductInfo = "searchToProductInfoSegue"
    
//      PRAGMA MARK: Row heights
    static let tableViewRowHeight:CGFloat = 85

//      PRAGMA MARK: Cell Size
    static let progressBarCellHeight:CGFloat = 100
    static let requestCellHeight:CGFloat = 130
    static let requestProductCellSize: CGFloat = 155
    static let requestLabelCellSize: CGFloat = 30
    static let requestLocationCellSize: CGFloat = 155
    static let requestFavoriteCellSize: CGFloat = 50
    static let requestExtraProductInfoCellSize: CGFloat = 400
    static let searchBarCellHeight:CGFloat = 60

//      PRAGMA MARK: Firebase
    static let firebaseFavoriteTable = "favorite"
    private static let firebaseDataroot = "dataroot"
    static let firebaseProductsTable = "products"
    static let firebaseFlightsTable = "flights"
    static let firebaseProductGroupsTable = "productGroups"
    static let firebaseRequestsTable = "requests"
    static let firebaseHouseTable = "houses"
    static let firebaseCrewTable = "crew"
    private static let keepFirebaseSynced = true

//      PRAGMA MARK: Calculate miles
    static let multiplierFactorMiles = 400

//      PRAGMA MARK: ID's
    static let housesCategoryID = "29"
    
//      PRAGMA MARK: Buttons
    static let popupButtonHeight = 60
    
//      PRAGMA MARK: Reusable identifiers
    static let progressbarCell: String = "progressCell"
    static let CCRequestCell: String = "CustomRequestCell"
    static let CCrequestProductInfo: String = "requestProductInfoCell"
    static let CCLocationLabel: String = "requestLocationLabelCell"
    static let CCLocationInfo: String = "requestLocationInfoCell"
    static let CCFavoritesLabel: String = "requestFavoritesLabelCell"
    static let CCfavoritesInfo: String = "favoritesInRequestCell"
    static let CCExtraProductDetail: String = "requestExtraProductDetailCell"
    static let CCExtraProductLabel: String = "requestExtraProductLabelCell"
    static let houseCell: String = "houseCell"
    
//      PRAGMA MARK: Reuse Strings
    static let requestPopupView: String = "requestPopupView"
    
//      PRAGMA MARK: Methods    
    static func isFirebaseSynced() -> Bool { return keepFirebaseSynced }
    
    private static func getRootRef() -> DatabaseReference { return Database.database().reference(withPath: firebaseDataroot) }
    
    static func getProductRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseProductsTable)
    }
    
    static func getFavoriteRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseFavoriteTable)
    }
    
    static func getRequestRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseRequestsTable)
    }
    
    static func getFlightsRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseFlightsTable)
    }
    
    static func getProductGroupRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseProductGroupsTable)
    }
    static func getHouseRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseHouseTable)
    }
    
    static func getCrewRef() -> DatabaseReference {
        let databaseRootRef = getRootRef()
        return databaseRootRef.child(firebaseCrewTable)
    }
    
    static func setRequest(requestLatestId: Int,productId: Int, customerChairNumber: String,
                              completed: Bool, flyingBlueNumber: String, flyingBlueMiles: String) {
        let requestRef = Constants.getRequestRef()
        let requestForItem = Request(
            id: requestLatestId + 1,
            productId: productId,
            customerChair: customerChairNumber,
            completed: completed,
            deviceID: Constants.DEVICEID,
            flyingBlueNumber: flyingBlueNumber,
            flyingBlueMiles: flyingBlueMiles
        )
        
        let requestForItemRef = requestRef.childByAutoId()
        requestForItemRef.setValue(requestForItem.toAnyObject())
    }
}
