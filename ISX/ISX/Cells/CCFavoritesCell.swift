//
//  FavoritesInRequestCell.swift
//  ISX
//
//  Created by Robby Michels on 28-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class CCFavoritesCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    
    func setProductName(productName: String) {
        self.productName.text = productName
    }
}
