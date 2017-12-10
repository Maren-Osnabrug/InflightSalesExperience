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

class RequestProductInfoCell: UITableViewCell {
    
    @IBOutlet weak var chairNumberView: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var deliveredBtn: UIButton!
    @IBOutlet weak var usersChairNumber: UILabel!
    @IBOutlet weak var productNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    func setCellData(productName: String, usersChairNumber: String, productNumber: String) {
        self.productName.text = productName
        self.usersChairNumber.text = usersChairNumber
        self.productNumber.text = "No. " + productNumber
    }
    
    @IBAction func onButtonClicked(_ sender: Any) {
        showInputDialog()
    }
    
    func setupStyling() {
        chairNumberView.layer.cornerRadius = Constants.chairNumberViewCornerRadius
        chairNumberView.layer.borderColor = Constants.radiusBorderColor
        chairNumberView.layer.borderWidth = 1 //deze zou ook nog constant kunnen zijn
        chairNumberView.layer.shadowColor = Constants.radiusShadowColor
        chairNumberView.layer.shadowOpacity = 0.8 //zelfde geldt voor deze
        chairNumberView.layer.shadowRadius = 3 //en deze
        chairNumberView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        deliveredBtn.layer.cornerRadius = Constants.buttonCornerRadius
        deliveredBtn.layer.borderColor = Constants.radiusBorderColor
    }
    
    func showInputDialog() {
        let popupVC = PopupViewController(nibName: "popupView", bundle: nil)
        let popup = PopupDialog(viewController: popupVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true)
        let cancelButton = CancelButton(title: "Cancel", height: 60) {
            print("sold button was canceled")
        }
        let requestButton = DefaultButton(title: "Yes", height: 60, dismissOnTap: false) {
            print("thing is sold")
        }
        
        popup.addButtons([cancelButton, requestButton])
        present(popup, animated: true, completion: nil)
    }
}
