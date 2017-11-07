//
//  ProductCell.swift
//  ISX
//
//  Created by Robby Michels on 10-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setCellData(product: Product){
        productImage.image = UIImage(named: product.id)
        if ((UIImage(named: product.id)) == nil){
            productImage.image = UIImage(named: "noImageAvailable")
        }
        productTitle.text = product.title
        productPrice.text = "€" + String(product.retailPrice)

    }
    
    func setupStyling(){
        backgroundColor = Constants.darkGrey
    }
    
}
