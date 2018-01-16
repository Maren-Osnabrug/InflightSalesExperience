//
//  Product.swift
//  ISX
//
//  Created by Maren Osnabrug on 27-09-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class Product {
    
    let bestsellers: String
    let productGroup: String
    let title: String
    let description: String
    let startDateSHC: String
    let brand: String
    let prologisticaNumberHH: String
    let id: String
    let retailPrice: Int
    var fbMiles: String = ""
    var drawer_EUR_Norway_Suisse: String
    var drawer_EUR_extended: String
    var drawer_EUR_reduced: String
    var drawer_ICA: String

//  self defined variables
    let ref: DatabaseReference?
    var image: UIImage?
    var url: String = "https://shop.klm.com/"
    var favorite: Bool = false
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        bestsellers = snapshotValue["Bestsellers"] as! String
        productGroup = snapshotValue["Product_group"] as! String
        title = (snapshotValue["Product_name_Holland_Herald_WBC_iPad"] as! String).capitalized
        description = snapshotValue["Sales_text_HH_WBC_iPad"] as! String
        startDateSHC = snapshotValue["Start_date_SHC"] as! String
        brand = snapshotValue["brand_id"] as! String
        prologisticaNumberHH = snapshotValue["prologistica_number_HH"] as! String
        id = snapshotValue["sku"] as! String
        image = UIImage(named: String(id)) == nil ? UIImage(named: Constants.noImageAvailable) : UIImage(named: String(id))
        if let productURL = snapshotValue["url"] as? String {
            url = productURL
        }

        if let norwayDrawer = snapshotValue["Drawer_EUR_Norway_Suisse"] as? String {
            drawer_EUR_Norway_Suisse = norwayDrawer
        } else {
            drawer_EUR_Norway_Suisse = "Not Available"
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
        if let productMiles = snapshotValue["FB_miles_EARN_ob_1_2_miles_per_Euro"] as? String {
            fbMiles = productMiles
        }
        ref = snapshot.ref
    }
    
    /*
     * For sending an object back to Firebase
     */
    func toAnyObject()-> Any {
        return [
            "Bestsellers": bestsellers,
            "Product_group": productGroup,
            "Product_name_Holland_Herald_WBC_iPad": title,
            "Sales_text_HH_WBC_iPad": description,
            "Start_date_SHC": startDateSHC,
            "brand_id": brand,
            "prologistica_number_HH": prologisticaNumberHH,
            "Drawer_EUR_Norway_Suisse": drawer_EUR_Norway_Suisse,
            "Drawer_EUR_extended": drawer_EUR_extended,
            "Drawer_EUR_reduced": drawer_EUR_reduced,
            "Drawer_ICA": drawer_ICA,
            "sku": id,
            "url": url,
            "Ob_Retail_price_1_PL-HH-WBC-iPad": retailPrice,
            "FB_miles_EARN_ob_1_2_miles_per_Euro": fbMiles
        ]
    }
}


