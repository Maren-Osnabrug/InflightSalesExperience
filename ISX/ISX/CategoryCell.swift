//
//  CategoryCell.swift
//  ISX
//
//  Created by Robby Michels on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    var categoryID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setCellData(category: Category){
        categoryID = category.categoryID
        categoryTitle.text = category.categoryName
        categoryImage.image = category.categoryImage
    }
    
    func setupStyling(){
        backgroundColor =  Constants.darkGrey
        categoryTitle.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        categoryTitle.textColor = UIColor.white
    }
}
