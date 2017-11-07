//
//  RequestCell.swift
//  ISX
//
//  Created by Maren Osnabrug on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class RequestCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCode: UILabel!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var chairView: UIView!
    @IBOutlet weak var chairLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }

    func setupStyling() {
        cellContentView.layer.borderColor = UIColor.white.cgColor
        cellContentView.layer.borderWidth = 1
        
        chairView.layer.cornerRadius = 15
        chairView.layer.borderColor = UIColor.clear.cgColor
        chairView.layer.borderWidth = 1
        chairView.layer.shadowColor = UIColor.lightGray.cgColor
        chairView.layer.shadowOpacity = 0.8
        chairView.layer.shadowRadius = 3
        chairView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func setCellData(request: Request) {
        contentView.layer.opacity = request.completed ? 0.25 : 1
        productImage.image = UIImage(named: String(request.productId)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(request.productId))
        productCode.text = String(request.productId)
        chairLabel.text = String(request.customerChair)
    }
}
