//
//  RequestSimpleProductInfoCell.swift
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

class RequestProductInfoCell: UITableViewCell {
    
    @IBOutlet weak var chairNumberView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var deliveredBtn: UIButton!
    @IBOutlet weak var usersChairNumber: UILabel!
    @IBOutlet weak var productNumber: UILabel!
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setCellData(productName: String, usersChairNumber: String, productNumber: String, productReference: DatabaseReference, isActive: Bool) {
        self.productName.text = productName
        self.usersChairNumber.text = usersChairNumber
        self.productNumber.text = "No. " + productNumber
        self.ref = productReference
        if(isActive) {
            setDeliveredButton(isActive: false, buttonColor: Constants.grey)
        }
    }
    
    @IBAction func onButtonClicked(_ sender: Any) {
        showSoldDialog()()
    }
    
    func setupStyling() {
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
    
    func showSoldDialog() {
        let popupVC = RequestPopupViewController(nibName: "requestPopupView", bundle: nil)
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true)
        let cancelButton = CancelButton(title: "Cancel", height: Constants.popupButtonHeight) {
            print("sold button was canceled")
        }
        let requestButton = DefaultButton(title: "Sold", height: Constants.popupButtonHeight) {
            self.ref?.updateChildValues([
                "completed": true
                ])
            self.setDeliveredButton(isActive: true, buttonColor: Constants.grey)
            self.showConfirmDialog()
        }

        popup.addButtons([cancelButton, requestButton])
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    func showConfirmDialog() {
        //Text can be changed ofcourse, its just some demo text
        let title = "Product sold!"
        let message = "Good Job! The overview of sold items will be updated. Keep up the good work!"
        
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
        let buttonOne = DefaultButton(title: "I understand") {}
        popup.addButton(buttonOne)
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
    }
    
    //Can be used to set button back to active aswell.
    func setDeliveredButton(isActive: Bool, buttonColor: UIColor) {
        deliveredBtn.isEnabled = isActive
        deliveredBtn.backgroundColor = buttonColor
    }
}
