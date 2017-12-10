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
import SceneKit
import PopupDialog

class ProductInfoController : UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimButton: UIButton!
    
    var addAlertSaveAction: UIAlertAction?
    var product: Product?
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    private var favoriteRef: DatabaseReference?
    var customerChair: String?

    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
    
    private let viewName = "Product information"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        title = product?.title
        setupReferences()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeFavoriteStatus()
    }
    
    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            product.changeFavoriteStatus()
            updateFavoriteButton(favorite: product.favorite)

            handleFavoriteInFirebase(isFavorite: product.favorite)
            GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Favorite", action: "Favorite product", label: product.title)
        }
    }
    
    @IBAction func didClickARButton(_ sender: Any) {
        performSegue(withIdentifier: "productInfoToARSegue", sender: self)
    }
    
    @IBAction func didClickRequestButton(_ sender: Any) {
        showInputDialog()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productInfoToARSegue" {
            if let controller = segue.destination as? ARViewController {
                if let ARproduct = product {
                    controller.product = ARproduct
                }
            }
        }
    }
    
    func showConfirmDialog(productName: String) {
        let title = "Request made!"
        let message = "Thank you for requesting \(productName). Cabin crew has been notified and will bring your item as soon as possible. Be advised this might take some time."

        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "I understand") {}
        popup.addButton(buttonOne)
        present(popup, animated: true, completion: nil)
    }
    
    func showInputDialog() {
        let popupVC = PopupViewController(nibName: "popupView", bundle: nil)
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true)
        let cancelButton = CancelButton(title: "Cancel", height: 60) {
        }
        let requestButton = DefaultButton(title: "I want it!", height: 60, dismissOnTap: false) {
            guard let customerChairNumber =  popupVC.chairNumberTextField.text else {return}
            guard let product = self.product else { return }
            
            if (!self.isValidChairNumber(chairNumber: customerChairNumber)) {
                popup.shake()
                return
            } else {
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
                            completed: false,
                            deviceID: Constants.DEVICEID
                        )
                        
                        let requestForItemRef = self.requestsRef?.childByAutoId()
                        requestForItemRef?.setValue(requestForItem.toAnyObject())
                    }
                })
                GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Product Information", action: "Interested in product", label: product.title)
                popup.dismiss()
                self.showConfirmDialog(productName: product.title)
            }
        }

        popup.addButtons([cancelButton, requestButton])
        present(popup, animated: true, completion: nil)

    }
    
    func observeFavoriteStatus() {
        if let productID = product?.id {
            favoriteRef?.child(Constants.DEVICEID).child(productID)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if (snapshot.hasChildren()) {
                        self.product?.changeFavoriteStatus()
                        self.updateFavoriteButton(favorite: true)
                    } else {
                        self.product?.changeFavoriteStatus()
                        self.updateFavoriteButton(favorite: false)
                    }
                })
        }
    }
    
    func setupReferences() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        requestsRef = datarootRef?.child("requests")
        favoriteRef = datarootRef?.child("favorite")
        requestsRef?.keepSynced(true)
    }
    
    func setupStyling() {
        guard let product = product else {
            return
        }
        productImageView.image = product.image
        productTitleLabel.text = product.title
        priceLabel.text = "€" + String(product.retailPrice)
        descriptionTextView!.text = product.description
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        favoriteButton.tintColor = Constants.orange
        updateFavoriteButton(favorite: product.favorite)
        if (SCNScene(named: "art.scnassets/\(String(describing: product.id))/\(String(describing: product.id)).scn") == nil) {
            ARButton.isHidden = true
        } else {
            ARButton.isHidden = false
        }
    }
    
    func updateFavoriteButton(favorite: Bool) {
        if (favorite) {
            favoriteButton.setImage(favoriteImage, for: .normal)
        } else {
            favoriteButton.setImage(unFavoriteImage, for: .normal)
        }
    }
    
    func isValidChairNumber(chairNumber: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.chairNumberRegex, options: [])
        if (regex.firstMatch(in: chairNumber, options: [], range: NSMakeRange(0, chairNumber.utf16.count)) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func handleFavoriteInFirebase(isFavorite: Bool) {
        if let productID = product?.id {
            if (isFavorite) {
                if let favProduct = self.product {
                    addFavoriteProduct(product: favProduct)
                }
            } else {
                deleteFavorite(productID: productID)
            }
        } else {
            return
        }
    }
    
    func addFavoriteProduct(product: Product) {
        let pushObjectToFirebase = favoriteRef?.child(Constants.DEVICEID).child(product.id)
        pushObjectToFirebase?.setValue(product.toAnyObject())
    }
    
    func deleteFavorite(productID: String) {
        favoriteRef?.child(Constants.DEVICEID).child(productID).removeValue()
    }
}
