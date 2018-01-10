//
//  ProductInfoCell.swift
//  ISX
//
//  Created by Robby Michels on 28-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog
import SceneKit
import FirebaseDatabase

class ProductInfoCell: UITableViewCell {
    @IBOutlet weak var chairNumberView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var deliveredBtn: UIButton!
    @IBOutlet weak var userChairNumber: UILabel!
    @IBOutlet weak var productNumber: UILabel!

    var productDetail: Product?
    var favorite: Favorite?
    var requestDetail: RequestDetail?
    var isFavorite: Bool = false
    var ref: DatabaseReference?
    var requestsRef: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setProductData(productName: String, usersChairNumber: String, productNumber: String, productReference: DatabaseReference, isActive: Bool) {
        self.productName.text = productName
        self.userChairNumber.text = usersChairNumber
        self.productNumber.text = "No. " + productNumber
        self.ref = productReference
        if(isActive) {
            setDeliveredButton(isActive: false, buttonColor: Constants.grey)
        }
    }
    
    func setFavoriteData(productName: String, productNumber: String, isFavorite: Bool, favorite: Favorite, requestDetail: RequestDetail) {
        self.productName.text = productName
        self.userChairNumber.text = requestDetail.chairnumber
        self.productNumber.text = "No. " + productNumber
        self.isFavorite = isFavorite
        self.favorite = favorite
        self.requestDetail = requestDetail
    }
    
    @IBAction func onDeliveredButtonClicked(_ sender: Any) {
        showSoldDialog()
    }
    
    func showSoldDialog() {
        let popupVC = RequestPopupViewController(nibName: Constants.requestPopupView, bundle: nil)
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true)
        let cancelButton = CancelButton(title: "Cancel", height: Constants.popupButtonHeight) {
        }
        let requestButton = DefaultButton(title: "Sold", height: Constants.popupButtonHeight) {
            if(self.isFavorite) {
                self.getLatestId()
            } else {
                self.ref?.updateChildValues([
                    "completed": true
                    ])
                self.setDeliveredButton(isActive: true, buttonColor: Constants.grey)
                self.showConfirmDialog()
            }
        }

        popup.addButtons([cancelButton, requestButton])
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    func showConfirmDialog() {
        let title = "Product sold!"
        let message = "Good Job! The sold items and sales amount will be updated. Keep up the good work!"
        
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "I understand") {}
        popup.addButton(buttonOne)
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    func showErrorDialog() {
        let title = "Oops, Something went wrong!"
        let message = "Try again later, something went wrong!"
        
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "I understand") {}
        popup.addButton(buttonOne)
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    // Can be used to set button back to active as well.
    func setDeliveredButton(isActive: Bool, buttonColor: UIColor) {
        deliveredBtn.isEnabled = isActive
        deliveredBtn.backgroundColor = buttonColor
    }
    
    func getLatestId() {
        let requestRef = Constants.getRequestRef()
        requestRef.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
            snapshot in
            var requestLatestId = 0
            for item in snapshot.children {
                let req = Request(snapshot: item as! DataSnapshot)
                requestLatestId = req.id
            }
            self.getProductInfo(latestId: requestLatestId)
        })
    }
    
    func getProductInfo(latestId: Int) {
        let productsRef = Constants.getProductRef()
        productsRef.keepSynced(Constants.isFirebaseSynced())
        
        productsRef.queryOrdered(byChild: "sku").queryEqual(toValue: favorite?.id).observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let product = item as? DataSnapshot {
                    self.productDetail = Product(snapshot: product)
                }
            }
            // Check if firebase returned anything, if not display error dialog.
            if(self.productDetail?.id != nil) {
                // If succeeded, add favorite as new request with completed on true, and remove the favorite.
                if let productID = Int((self.productDetail?.id)!) {
                    Constants.setRequest(requestLatestId: latestId, productId: productID, customerChairNumber: self.userChairNumber.text!, completed: Constants.requestIsCompleted, flyingBlueNumber: Constants.emptyString, flyingBlueMiles: (self.productDetail?.fbMiles)!)
                    let favoriteRef = Constants.getFavoriteRef()
                    favoriteRef.child((self.requestDetail?.deviceId)!).child((self.favorite?.id)!).removeValue()
                    self.showConfirmDialog()
                }
            } else {
                self.showErrorDialog()
            }
        })
    }
    
    // PRAGMA MARK: - Private
    private func setupStyling() {
        chairNumberView.layer.cornerRadius = Constants.chairNumberViewCornerRadius
        chairNumberView.layer.borderColor = Constants.radiusBorderColor
        chairNumberView.layer.borderWidth = Constants.cellBorderWidth
        chairNumberView.layer.shadowColor = Constants.radiusShadowColor
        chairNumberView.layer.shadowOpacity = Constants.shadowOpacity
        chairNumberView.layer.shadowRadius = Constants.shadowRadius
        chairNumberView.layer.shadowOffset = Constants.shadowOffset
        
        deliveredBtn.layer.cornerRadius = Constants.buttonCornerRadius
        deliveredBtn.layer.borderColor = Constants.radiusBorderColor
    }
}
