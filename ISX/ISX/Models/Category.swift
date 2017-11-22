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
    var categoryImage: UIImage?
    let ref: DatabaseReference?
        
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:AnyObject]
        categoryID = dict["ID"] as! String
        categoryName = dict["Product_groep"] as! String
        self.ref = snapshot.ref
    }
    
    func setCategoryImage(image: UIImage) {
        categoryImage = image
    }
}
