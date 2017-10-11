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

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productImages: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = product?.title
        priceLabel!.text = "€" + product!.retailPrice
        descriptionTextView!.text = product?.description
        productImages.image = UIImage(named: "parfum")
        
    }
}
