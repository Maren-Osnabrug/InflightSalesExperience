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
    
    func setCellData(house: House) {
        houseImage.image = house.image
        houseNumber.text = house.id
    }
}
