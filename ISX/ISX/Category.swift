//
//  Category.swift
//  ISX
//
//  Created by Robby Michels on 18-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class Category {
    
    let categoryID: String
    let categoryName: String
    let categoryImage: UIImage
    let ref: DatabaseReference?
    
    //fetch from firebase later.
    var categoryImages = ["sieraden", "parfum", "elektronica", "reizen", "sieraden",
                          "parfum", "elektronica", "reizen", "sieraden", "parfum", "elektronica", "reizen"]
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:AnyObject]
        categoryID = dict["ID"] as! String
        categoryName = dict["Product_groep"] as! String
        categoryImage = UIImage(named: self.categoryImages[Int(arc4random_uniform(UInt32(self.categoryImages.count)))])!
        self.ref = snapshot.ref
    }
}
