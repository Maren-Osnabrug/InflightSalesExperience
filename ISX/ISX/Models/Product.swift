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
//    let localPrice: String = ""
//    let Did_You_Know_iPad: String = ""

    var drawer_EUR_Norway_Suisse: String
    var drawer_EUR_extended: String
    var drawer_EUR_reduced: String
    var drawer_ICA: String
//    let FB_miles_EARN_ob_1_2_miles_per_Euro: String = ""

//    let Free_gift: String = ""
//    let KLM_Only: String = ""
//    let Save_21: String = ""
//    let Tax_Free_Exclusive: Bool = false

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
        image = UIImage(named: String(id)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(id))
        if let productURL = snapshotValue["url"] as? String {
            url = productURL
        }

        if let norwayDrawer = snapshotValue["Drawer_EUR_Norway_Suisse"] as? String {
            drawer_EUR_Norway_Suisse = norwayDrawer
        } else {
            drawer_EUR_Norway_Suisse = "200"
        }
        
        if let extendedDrawer = snapshotValue["Drawer_EUR_extended"] as? String {
            drawer_EUR_extended = extendedDrawer
        }else {
            drawer_EUR_extended = "Not Available"
        }
        
        if let reducedDrawer = snapshotValue["Drawer_EUR_reduced"] as? String {
            drawer_EUR_reduced = reducedDrawer
        }else {
            drawer_EUR_reduced = "Not Available"
        }
        
        if let icaDrawer = snapshotValue["Drawer_ICA"] as? String {
            drawer_ICA = icaDrawer
        }else {
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

        //        localPrice = snapshotValue["local_price"] != nil ? snapshotValue["local_price"] as! String : ""
        //        Did_You_Know_iPad = snapshotValue["Did_You_Know_iPad"] as! String
        //        Drawer_EUR_Norway_Suisse = snapshotValue["Drawer_EUR_Norway_Suisse"] as! String
        //        Drawer_EUR_extended = snapshotValue["Drawer_EUR_extended"] as! String
        //        Drawer_EUR_reduced = snapshotValue["Drawer_EUR_reduced"] as! String
        //        Drawer_ICA = snapshotValue["Drawer_ICA"] as! String
        //        Free_gift = snapshotValue["Free_gift"] as! String
        //        KLM_Only = snapshotValue["KLM_Only"] as! String
        //        Save_21 = snapshotValue["Save_21"] as! String
        //        Tax_Free_Exclusive = snapshotValue["Tax_Free_Exclusive"] as! String
    }
    
    func changeFavoriteStatus() {
        favorite = !favorite
    }
    
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


