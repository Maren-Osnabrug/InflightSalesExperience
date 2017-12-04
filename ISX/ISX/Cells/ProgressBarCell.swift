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
    
    @IBOutlet weak var highestRevenueLabel: UILabel!
    @IBOutlet weak var currentRevenueLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var averageRevenueLabel: UILabel!
    
    var omzetArray = [124, 125, 874]
    
    func setProgressBar (flight: Flight) {
        let progress = (Float(flight.averageRevenue)/Float(flight.highestRevenue))
        currentRevenueLabel.text = "Current Revenue: €\(flight.averageRevenue)"
        highestRevenueLabel.text = "Highest Revenue: €\(flight.highestRevenue)"
        averageRevenueLabel.text = "€\(flight.highestRevenue)"
        progressBar.setProgress(progress, animated: true)
    }
}
