//
//  FavoritesCell.swift
//  ISX
//
//  Created by Maren Osnabrug on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class FavoritesCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var labelContainingView: UIView!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }

    func updateWithFavorite(favorite: Product) {
        productImage.image = UIImage(named: String(favorite.id)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(favorite.id))
        productName.text = favorite.title
        productPrice.text = "€ " + String(favorite.retailPrice)
    }
    
    // PRAGMA MARK: - Private
    private func setupStyling() {
        cellContentView.layer.borderColor = UIColor.white.cgColor
        cellContentView.layer.borderWidth = 1
    }
}
