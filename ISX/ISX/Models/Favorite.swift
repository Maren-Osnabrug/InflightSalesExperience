//
//  Favorite.swift
//  ISX
//
//  Created by Robby Michels on 08-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Favorite {

    let bestsellers: String!
    let productGroup: String!
    let title: String!
    let description: String!
    let startDateSHC: String!
    let brand: String!
    let prologistricaNumberHH: String!
    let id: String!
    let image: UIImage!
    let retailPrice: Int!
    let drawer_EUR_Norway_Suisse: String
    let drawer_EUR_extended: String
    let drawer_EUR_reduced: String
    let drawer_ICA: String
    let ref: DatabaseReference
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        bestsellers = snapshotValue["Bestsellers"] as! String
        productGroup = snapshotValue["Product_group"] as! String
        title = (snapshotValue["Product_name_Holland_Herald_WBC_iPad"] as! String).capitalized
        description = snapshotValue["Sales_text_HH_WBC_iPad"] as! String
        startDateSHC = snapshotValue["Start_date_SHC"] as! String
        brand = snapshotValue["brand_id"] as! String
        prologistricaNumberHH = snapshotValue["prologistica_number_HH"] as! String
        id = snapshotValue["sku"] as! String
        image = UIImage(named: String(id)) == nil ? UIImage(named: Constants.noImageAvailable) : UIImage(named: String(id))
        //drawer_EUR_Norway_Suisse = snapshotValue["Drawer_EUR_Norway_Suisse"] as! String
        if let norwayDrawer = snapshotValue["Drawer_EUR_Norway_Suisse"] as? String {
            drawer_EUR_Norway_Suisse = norwayDrawer
        } else {
            drawer_EUR_Norway_Suisse = "200"
        }
        
        if let extendedDrawer = snapshotValue["Drawer_EUR_extended"] as? String {
            drawer_EUR_extended = extendedDrawer
        } else {
            drawer_EUR_extended = "Not Available"
        }
        
        if let reducedDrawer = snapshotValue["Drawer_EUR_reduced"] as? String {
            drawer_EUR_reduced = reducedDrawer
        } else {
            drawer_EUR_reduced = "Not Available"
        }
        
        if let icaDrawer = snapshotValue["Drawer_ICA"] as? String {
            drawer_ICA = icaDrawer
        } else {
            drawer_ICA = "Not Available"
        }
        
        if let price = snapshotValue["Ob_Retail_price_1_PL-HH-WBC-iPad"] as? Int {
            retailPrice = price
        } else {
            retailPrice = 0
        }
        self.ref = snapshot.ref
    }
    
}
