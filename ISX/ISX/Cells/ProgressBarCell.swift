//
//  ProgressBarCell.swift
//  ISX
//
//  Created by Jasper Zwiers on 21-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class ProgressBarCell: UITableViewCell {
    @IBOutlet weak var opbrengstLabel: UILabel!
    @IBOutlet weak var hoogsteOpbrengstLabel: UILabel!
    
    var omzetArray = [124, 125, 1874]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        opbrengstLabel.text = "Huidige opbrengst: €\(omzetArray[1])"
        hoogsteOpbrengstLabel.text = "Hoogste opbrengst: €\(omzetArray[2])"
        //        progressBar.setProgress
    }
    
    
}
