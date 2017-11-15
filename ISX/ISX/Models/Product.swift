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
    var image: UIImage?
    // self defined variables
    let ref: DatabaseReference?
    var favorite: Bool
    
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
        
        if let price = Int(snapshotValue["Ob_Retail_price_1_PL-HH-WBC-iPad"] as! String) {
            retailPrice = price
        } else {
           retailPrice = 0
        }
        
        self.ref = snapshot.ref
        if (snapshotValue["favorite"] == nil) {
            snapshot.ref.updateChildValues([
                "favorite": false
                ])
            favorite = false
        } else {
            favorite = snapshotValue["favorite"] as! Bool
        }
    }
    
    func setProductImage(productImage: UIImage) {
        image = productImage
    }
    
    func changeFavoriteStatus() {
        ref?.updateChildValues([
            "favorite": !self.favorite
            ])
        favorite = !favorite
    }
}


