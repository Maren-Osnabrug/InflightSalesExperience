//
//  RequestPopupViewController.swift
//  ISX-CabinCrew
//
//  Created by Robby Michels on 12-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit

class RequestPopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RequestPopupViewController.endEditing)))
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
}
