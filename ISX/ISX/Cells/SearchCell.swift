//
//  SearchCell.swift
//  ISX
//
//  Created by Jasper Zwiers on 13-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSearchCell(product: Product) {
        productNameLabel.text = product.title
        productImage.image = product.image
    }
    
}
