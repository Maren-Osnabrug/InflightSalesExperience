//
//  RequestLocationInfoCell.swift
//  ISX
//
//  Created by Robby Michels on 29-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class RequestLocationInfoCell: UITableViewCell {
    @IBOutlet weak var productDrawerEurNorway: UILabel!
    @IBOutlet weak var productDrawerEurExt: UILabel!
    @IBOutlet weak var productDrawerEurReduced: UILabel!
    @IBOutlet weak var productDrawerIca: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    func setCellData(product: Product) {
        self.productDrawerEurNorway.text = "Drawer Norway: " + product.drawer_EUR_Norway_Suisse
        self.productDrawerEurExt.text = "Drawer Extended: " + product.drawer_EUR_extended
        self.productDrawerEurReduced.text = "Drawer Reduced: " + product.drawer_EUR_reduced
        self.productDrawerIca.text = "Drawer ICA: " + product.drawer_ICA
        self.productImage.image = product.image
    }
}
