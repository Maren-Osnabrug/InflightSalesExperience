//
//  Category.swift
//  ISX
//
//  Created by Robby Michels on 18-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    let categoryID: String
    let categoryName: String
    let categoryImage: UIImage
    
    init(categoryID: String, categoryName: String, categoryImage: UIImage){
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryImage = categoryImage
    }
    
}
