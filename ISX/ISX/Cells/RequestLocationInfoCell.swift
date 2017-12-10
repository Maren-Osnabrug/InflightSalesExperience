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
    
    @IBOutlet weak var productDrawerInfo: UILabel!
    @IBOutlet weak var productMiles: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    func setCellData(product: Product) {
        self.productDrawerInfo.text = "Drawer: " + product.drawer_EUR_Norway_Suisse
        self.productMiles.text = formatBigNumber(retailPrice: product.retailPrice)
        self.productImage.image = product.image
        self.productPrice.text = "Retailprice: € " + String(product.retailPrice) + ",-"
    }
    
    func formatBigNumber(retailPrice: Int) -> String{
        let largeNumber = retailPrice * 400
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)){
            return "Air Miles: " + formattedNumber
        }
        return "No retailprice found"
    }
}
