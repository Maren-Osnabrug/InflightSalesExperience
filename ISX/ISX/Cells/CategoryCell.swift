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
    
    func setCategoryData(category: Category){
        categoryID = category.categoryID
        categoryTitle.text = category.categoryName
        categoryImage.image = UIImage(named: String(category.categoryID)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(category.categoryID))
    }
    
    // PRAGMA MARK: - Private
    private func setupStyling() {
        backgroundColor =  Constants.darkGrey
        categoryTitle.textColor = .white
    }
}
