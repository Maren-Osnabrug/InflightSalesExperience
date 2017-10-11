//
//  ProductInfoController.swift
//  ISX
//
//  Created by Robby Michels on 11-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class ProductInfoController : UIViewController {
    
    var product: Product?
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var claimButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = product?.title
        productImageView.image = UIImage(named: "parfum")
        productTitleLabel.text = product?.title
        priceLabel.text = "€" + (product?.retailPrice)!
        descriptionTextView!.text = product?.description
        favoriteImageView.image = UIImage(named: "Heart")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        favoriteImageView.tintColor = Constants.orange
    }
}
