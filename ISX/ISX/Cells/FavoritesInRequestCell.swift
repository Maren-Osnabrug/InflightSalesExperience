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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellData(favorite: Favorite) {
        productName.text = favorite.title
    }
    
    func setProductName(productName: String) {
        self.productName.text = productName
    }
}
