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
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimButton: UIButton!
    
    var product: Product?

    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)

    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            product.changeFavoriteStatus()
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
        descriptionTextView.textContainerInset = .zero
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
