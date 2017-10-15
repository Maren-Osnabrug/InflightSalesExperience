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
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var claimButton: UIButton!
    
    let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            print("before", product.favorite)
            product.changeFavoriteStatus()
            print("after", product.favorite)
            updateFavoriteButton(favorite: product.favorite)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product?.title
        setupStyling()
    }
    
    func setupStyling() {
        guard let product = product else {
            return
        }
        productImageView.image = UIImage(named: "parfum")
        productTitleLabel.text = product.title
        priceLabel.text = "€" + (product.retailPrice)
        descriptionTextView!.text = product.description
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        favoriteButton.tintColor = Constants.orange
        updateFavoriteButton(favorite: product.favorite)
    }
    
    func updateFavoriteButton(favorite: Bool) {
        if (favorite) {
            favoriteButton.setImage(favoriteImage, for: .normal)
        } else {
            favoriteButton.setImage(unFavoriteImage, for: .normal)
        }
    }
}
