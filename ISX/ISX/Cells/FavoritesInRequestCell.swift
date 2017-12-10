//
//  FavoritesInRequestCell.swift
//  ISX
//
//  Created by Robby Michels on 28-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class FavoritesInRequestCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
//    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //setupStyling()
    }
    
    func setCellData(favorite: Favorite) {
        productName.text = favorite.title
    }
    
    func setProductName(productName: String) {
        self.productName.text = productName
    }
    
//    // PRAGMA MARK: - Private
//    private func setupStyling() {
//        cellContentView.layer.borderColor = UIColor.white.cgColor
//        cellContentView.layer.borderWidth = 1
//    }
}
