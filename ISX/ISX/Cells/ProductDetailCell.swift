//
//  RequestExtraProductDetailCell.swift
//  ISX-CabinCrew
//
//  Created by Robby Michels on 05-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class ProductDetailCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageInView()
    }
    
    func setImageInView() {
        let imageName = "ifihadapdf"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = Constants.imageViewFrame
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        cellView.addSubview(imageView)
    }
}
