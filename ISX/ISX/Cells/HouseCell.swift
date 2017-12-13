//
//  HouseCell.swift
//  ISX
//
//  Created by Rosyl Budike on 13-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit

class HouseCell: UICollectionViewCell {
    @IBOutlet weak var houseImage: UIImageView!
    
    @IBOutlet weak var houseNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setCellData(product: Product) {
    }
    
    private func setupStyling() {
        backgroundColor = Constants.darkGrey
    }
}
