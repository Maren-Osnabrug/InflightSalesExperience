//
//  RequestExtraProductDetailCell.swift
//  ISX-CabinCrew
//
//  Created by Robby Michels on 05-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class RequestExtraProductDetailCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageInView()
    }
    
    func setImageInView() {
        let imageName = "ifihadapdf"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        cellView.addSubview(imageView)
    }
}
