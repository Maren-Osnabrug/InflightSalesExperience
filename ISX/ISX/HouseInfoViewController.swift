//
//  HouseInfoViewController.swift
//  ISX
//
//  Created by Rosyl Budike on 13-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit

class HouseInfoViewController: UITableViewController {

    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var houseTitle: UILabel!
    @IBOutlet weak var houseNumber: UILabel!
    @IBOutlet weak var houseDescription: UILabel!
    @IBOutlet weak var reserveHouseButton: UIButton!

    var house: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyling()
        title = house?.title

        self.tableView.estimatedRowHeight = Constants.tableViewRowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setupStyling() {
        guard let house = house else {
            return
        }
        houseImage.image = house.image
        houseTitle.text = house.title
        houseNumber.text = house.id
        houseDescription.text = house.description
    }
}
