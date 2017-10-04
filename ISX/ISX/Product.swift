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
    let sku: String
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
    
    init(Bestsellers: String, Product_group: String, Product_name_Holland_Herald_WBC_iPad: String, Sales_text_HH_WBC_iPad: String,
        Start_date_SHC: String, brand_id: String, local_price: String, prologistica_number_HH: String, sku: String,
                retailPrice: String,
                Did_You_Know_iPad: String,
                Drawer_EUR_Norway_Suisse: String,
                Drawer_EUR_extended: String,
                Drawer_EUR_reduced: String,
                Drawer_ICA: String,
                FB_miles_EARN_ob_1_2_miles_per_Euro: String,
                Free_gift: String,
                KLM_Only: String,
                Save_21: String,
                Tax_Free_Exclusive: String
        ) {
        self.bestsellers = Bestsellers
        self.productGroup = Product_group
        self.title = Product_name_Holland_Herald_WBC_iPad
        self.description = Sales_text_HH_WBC_iPad
        self.startDateSHC = Start_date_SHC
        self.brand = brand_id
//        self.localPrice = local_price
        self.prologisticaNumberHH = prologistica_number_HH
        self.sku = sku
        self.retailPrice = retailPrice
        //        self.Did_You_Know_iPad = Did_You_Know_iPad
        //        self.Drawer_EUR_Norway_Suisse = Drawer_EUR_Norway_Suisse
        //        self.Drawer_EUR_extended = Drawer_EUR_extended
        //        self.Drawer_EUR_reduced = Drawer_EUR_reduced
        //        self.Drawer_ICA = Drawer_ICA
        //        self.FB_miles_EARN_ob_1_2_miles_per_Euro = FB_miles_EARN_ob_1_2_miles_per_Euro
        //        self.Free_gift = Free_gift
        //        self.KLM_Only = KLM_Only
        //        self.Save_21 = Save_21
        //        self.Tax_Free_Exclusive = Tax_Free_Exclusive
    }
    
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
        sku = snapshotValue["sku"] as! String
        retailPrice = snapshotValue["Ob_Retail_price_1_PL-HH-WBC-iPad"] as! String

//        print(snapshotValue)
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
    
    func toAnyObject() -> Any {
        return [
            "Bestsellers" : bestsellers,
            "Product_group" : productGroup,
            "Product_name_Holland_Herald_WBC_iPad" : title,
            "Sales_text_HH_WBC_iPad" : description,
            "Start_date_SHC" : startDateSHC,
            "brand_id" : brand,
            "local_price" : localPrice,
            "prologistica_number_HH" : prologisticaNumberHH,
            "Ob_Retail_price_1_PL_HH_WBC_iPad" : retailPrice,
            "sku" : sku
            //            "Did_You_Know_iPad" : Did_You_Know_iPad,
            //            "Drawer_EUR_Norway_Suisse" : Drawer_EUR_Norway_Suisse,
            //            "Drawer_EUR_extended" : Drawer_EUR_extended,
            //            "Drawer_EUR_reduced" : Drawer_EUR_reduced,
            //            "Drawer_ICA" : Drawer_ICA,
            //            "FB_miles_EARN_ob_1_2_miles_per_Euro" : FB_miles_EARN_ob_1_2_miles_per_Euro,
            //            "Free_gift" : Free_gift,
            //            "KLM_Only" : KLM_Only,
            //            "Save_21" : Save_21,
            //            "Tax_Free_Exclusive" : Tax_Free_Exclusive,
        ]
    }
}


