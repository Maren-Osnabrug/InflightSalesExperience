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

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

class ProductInfoController : UITableViewController {
    @IBOutlet weak var productInfoTableView: UITableView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var claimButton: UIButton!
    
    var product: Product?
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    private var favoriteRef: DatabaseReference?
    var customerChair: String?
    var addAlertSaveAction: UIAlertAction?

    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
    
    private let viewName = "Product information"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
        GoogleAnalyticsHelper().googleAnalyticLogScreen(screen: viewName)
        title = product?.title
        setupReferences()
        self.tableView.estimatedRowHeight = Constants.tableViewRowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeFavoriteStatus()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setupStyling() {
        guard let product = product else {
            return
        }
        productImageView.image = product.image
        productTitleLabel.text = product.title
        priceLabel.text = "€ " + String(product.retailPrice)
        milesLabel.text = "Or " + String((product.retailPrice*Constants.multiplierFactorMiles).withCommas()) + " Miles"
        descriptionLabel.text = product.description
        updateFavoriteButton(favorite: product.favorite)
        if (SCNScene(named: "art.scnassets/\(String(describing: product.id))/\(String(describing: product.id)).scn") == nil) {
            ARButton.isHidden = true
        } else {
            ARButton.isHidden = false
        }
    }

    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            product.favorite = !product.favorite
            updateFavoriteButton(favorite: product.favorite)
            handleFavoriteInFirebase(isFavorite: product.favorite)
            GoogleAnalyticsHelper().googleAnalyticLogAction(category: "Favorite", action: "Favorite product", label: product.title)
        }
    }
    
    @IBAction func didClickARButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.productInfoToAR, sender: self)
    }
    
    @IBAction func didClickRequestButton(_ sender: Any) {
        showOrderDialog()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.productInfoToAR {
            if let controller = segue.destination as? ARViewController {
                if let ARproduct = product {
                    controller.product = ARproduct
                }
            }
        } else if segue.identifier == Constants.productInfoToWeb {
            if let controller = segue.destination as? WebViewController {
                if let url = product?.url {
                    controller.url = URL(string: url)!
                }
            }
        }
    }
    
    func showOrderDialog() {
        let title = "Delivery now or later?"
        let message = "If you are currently on a plane -> press Now. If you want the product delivered on a different flight or at home -> press later."
        
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal,
                                transitionStyle: .bounceUp, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "Now") { self.showInputDialog()}
        let buttonTwo = DefaultButton(title: "Later") {
            self.performSegue(withIdentifier:  Constants.productInfoToWeb, sender: self)
        }
        popup.addButtons([buttonOne, buttonTwo])
        present(popup, animated: true, completion: nil)
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
            var flyingBlueNumber = ""
            if (popupVC.flyingBlueNumberTextField.text == nil) {
                flyingBlueNumber = ""
            } else {
                flyingBlueNumber = popupVC.flyingBlueNumberTextField.text!
            }
            
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
                            deviceID: Constants.DEVICEID,
                            flyingBlueNumber: flyingBlueNumber,
                            flyingBlueMiles: product.fbMiles

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
                        self.product?.favorite = true
                        self.updateFavoriteButton(favorite: true)
                    } else {
                        self.product?.favorite = false
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

    func updateFavoriteButton(favorite: Bool) {
        if (favorite) {
            favoriteButton.setImage(favoriteImage, for: .normal)
        } else {
            favoriteButton.setImage(unFavoriteImage, for: .normal)
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
