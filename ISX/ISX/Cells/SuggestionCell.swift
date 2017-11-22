//
//  SuggestionProductCell.swift
//  ISX
//
//  Created by Rosyl Budike on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit

class SuggestionCell: UICollectionViewCell {

    @IBOutlet weak var suggestionImage: UIImageView!
    @IBOutlet weak var suggestionTextContainer: UIView!
    @IBOutlet weak var suggestionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(product: Product) {
        suggestionImage.image = product.image
        suggestionTitleLabel.text = product.title
    }
}
