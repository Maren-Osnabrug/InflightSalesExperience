//
//  Product.swift
//  ISX
//
//  Created by Maren Osnabrug on 27-09-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Product {
    
    let bestsellers: String
    let productGroup: String
    let title: String
    let description: String
    let startDateSHC: String
    let brand: String
    let localPrice: String = ""
    let prologisticaNumberHH: String
    let id: String
    let retailPrice: String
    let Did_You_Know_iPad: String = ""
    let Drawer_EUR_Norway_Suisse: String = ""
    let Drawer_EUR_extended: String = ""
    let Drawer_EUR_reduced: String = ""
    let Drawer_ICA: String = ""
    let FB_miles_EARN_ob_1_2_miles_per_Euro: String = ""
    let Free_gift: String = ""
    let KLM_Only: String = ""
    let Save_21: String = ""
    let Tax_Free_Exclusive: Bool = false
    // self defined variables
    let ref: DatabaseReference?
    var favorite: Bool
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        bestsellers = snapshotValue["Bestsellers"] as! String
        productGroup = snapshotValue["Product_group"] as! String
        title = snapshotValue["Product_name_Holland_Herald_WBC_iPad"] as! String
        description = snapshotValue["Sales_text_HH_WBC_iPad"] as! String
        startDateSHC = snapshotValue["Start_date_SHC"] as! String
        brand = snapshotValue["brand_id"] as! String
//        localPrice = snapshotValue["local_price"] != nil ? snapshotValue["local_price"] as! String : ""
        prologisticaNumberHH = snapshotValue["prologistica_number_HH"] as! String
        id = snapshotValue["sku"] as! String
        retailPrice = snapshotValue["Ob_Retail_price_1_PL-HH-WBC-iPad"] as! String
        self.ref = snapshot.ref
        if (snapshotValue["favorite"] == nil) {
            snapshot.ref.updateChildValues([
                "favorite": false
                ])
            favorite = false
        } else {
            favorite = snapshotValue["favorite"] as! Bool
        }
        
        //        Did_You_Know_iPad = snapshotValue["Did_You_Know_iPad"] as! String
        //        Drawer_EUR_Norway_Suisse = snapshotValue["Drawer_EUR_Norway_Suisse"] as! String
        //        Drawer_EUR_extended = snapshotValue["Drawer_EUR_extended"] as! String
        //        Drawer_EUR_reduced = snapshotValue["Drawer_EUR_reduced"] as! String
        //        Drawer_ICA = snapshotValue["Drawer_ICA"] as! String
        //        FB_miles_EARN_ob_1_2_miles_per_Euro = snapshotValue["FB_miles_EARN_ob_1_2_miles_per_Euro"] as! String
        //        Free_gift = snapshotValue["Free_gift"] as! String
        //        KLM_Only = snapshotValue["KLM_Only"] as! String
        //        Save_21 = snapshotValue["Save_21"] as! String
        //        Tax_Free_Exclusive = snapshotValue["Tax_Free_Exclusive"] as! String
    }
    
    func changeFavoriteStatus() {
        ref?.updateChildValues([
            "favorite": !self.favorite
            ])
        favorite = !favorite
    }
}


