//
//  ProductInfoController.swift
//  ISX
//
//  Created by Robby Michels on 11-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ProductInfoController : UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimButton: UIButton!
    
    var product: Product?
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    var customerChair: String?

    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
    
    private let viewName = "Product information"

    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            product.changeFavoriteStatus()
            updateFavoriteButton(favorite: product.favorite)
            GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Favorite", action: "Favorite product", label: product.title)
        }
    }
    
    @IBAction func didClickRequestButton(_ sender: Any) {
        showInputDialog()
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Enter your seatnumber", message: "Please enter your seat number so we can deliver your product.", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            guard let customerChairNumber = alertController.textFields?.first?.text else { return }
            guard let product = self.product else { return }

            self.requestsRef?.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                snapshot in
                var requestLatestId = 0
                for item in snapshot.children {
                    let req = Request.init(snapshot: item as! DataSnapshot)
                    requestLatestId = req.id
                }
                if let productId = Int(product.id) {
                    let requestForItem = Request(
                        id: requestLatestId + 1,
                        productId: productId,
                        customerChair: customerChairNumber,
                        completed: false
                    )
                    
                    let requestForItemRef = self.requestsRef?.childByAutoId()
                    requestForItemRef?.setValue(requestForItem.toAnyObject())
                }
            })
            
            GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Product Information", action: "Interested in product", label: product.title)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        
        title = product?.title
        setupReferences()
        setupStyling()
    }
    
    func setupReferences() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        requestsRef = datarootRef?.child("requests")
        requestsRef?.keepSynced(true)
    }
    
    func setupStyling() {
        guard let product = product else {
            return
        }
        productImageView.image = UIImage(named: String(product.id)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(product.id))
        productTitleLabel.text = product.title
        priceLabel.text = "€" + String(product.retailPrice)
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
