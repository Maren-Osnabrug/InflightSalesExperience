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

//      PRAGMA MARK: Display strings
    static let sortBy = "Sort by: "
    
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

//      PRAGMA MARK: Segues
    static let productInfoToWeb = "productInfoToWebSegue"
    static let productInfoToAR = "productInfoToARSegue"
    static let homeToProductInfo = "homeToProductInfoSegue"
    static let categoryToHouses = "categoryToHousesSeque"
    static let houseToInfo = "houseToInfoSeque"
    
//      PRAGMA MARK: Row heights
    static let tableViewRowHeight:CGFloat = 85

//      PRAGMA MARK: Cells
    static let progressBarCellHeight:CGFloat = 100
    static let requestCellHeight:CGFloat = 130
    
//      PRAGMA MARK: Calculate miles
    static let multiplierFactorMiles = 400
}
