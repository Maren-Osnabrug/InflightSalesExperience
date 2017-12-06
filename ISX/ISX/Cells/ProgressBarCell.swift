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
    
    @IBOutlet weak var targetRevenueTextLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var targetRevenueAmountLabel: UILabel!
    
    func setProgressBar (flight: Flight, currentRevenue: Int) {
        var progress: Float
        if(currentRevenue <= flight.averageRevenue) {
            progress = (Float(currentRevenue)/Float(flight.averageRevenue))
            targetRevenueTextLabel.text = "Target Revenue: €\(currentRevenue)/€\(flight.averageRevenue)"
            targetRevenueAmountLabel.text = "€\(flight.averageRevenue)"
        } else {
            progress = (Float(currentRevenue)/Float(flight.highestRevenue))
            targetRevenueTextLabel.text = "Target Revenue: €\(currentRevenue)/€\(flight.highestRevenue)"
            targetRevenueAmountLabel.text = "€\(flight.highestRevenue)"
        }
        progressBar.setProgress(progress, animated: true)
    }
}
