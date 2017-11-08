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
    @IBOutlet weak var suggestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setupStyling() {
        backgroundColor = Constants.grey
        suggestionTextContainer.backgroundColor = Constants.blue
    }
    
    func setupData(product: Product) {
        suggestionImage.image = UIImage(named: String(product.id)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(product.id))
        suggestionLabel.text = product.title
    }
}
