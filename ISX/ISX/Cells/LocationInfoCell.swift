//
//  RequestLocationInfoCell.swift
//  ISX
//
//  Created by Robby Michels on 29-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class LocationInfoCell: UITableViewCell {
    @IBOutlet weak var productDrawerEurNorway: UILabel!
    @IBOutlet weak var productDrawerEurExt: UILabel!
    @IBOutlet weak var productDrawerEurReduced: UILabel!
    @IBOutlet weak var productDrawerIca: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    func setProductData(product: Product) {
        productDrawerEurNorway.text = "Drawer Norway: " + product.drawer_EUR_Norway_Suisse
        productDrawerEurExt.text = "Drawer Extended: " + product.drawer_EUR_extended
        productDrawerEurReduced.text = "Drawer Reduced: " + product.drawer_EUR_reduced
        productDrawerIca.text = "Drawer ICA: " + product.drawer_ICA
        productImage.image = product.image
    }
    
    func setFavoriteData(product: Favorite) {
        productDrawerEurNorway.text = "Drawer Norway: " + product.drawer_EUR_Norway_Suisse
        productDrawerEurExt.text = "Drawer Extended: " + product.drawer_EUR_extended
        productDrawerEurReduced.text = "Drawer Reduced: " + product.drawer_EUR_reduced
        productDrawerIca.text = "Drawer ICA: " + product.drawer_ICA
        productImage.image = product.image
    }
}
