//
//  PopupViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 28-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
class PopupViewController: UIViewController {
    
    @IBOutlet weak var chairNumberTextField: UITextField!
    
    @IBOutlet weak var flyingBlueNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chairNumberTextField.delegate = self
        chairNumberTextField.autocapitalizationType = .allCharacters
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopupViewController.endEditing)))
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let chairnumber = sender.text else { return }
        if (isValidChairNumber(chairNumber: chairnumber)) {
            sender.textColor = Constants.okayGreen
        } else {
            sender.textColor = .red
        }
    }

    @objc func endEditing() {
        view.endEditing(true)
    }

    /*
     * For checking the chairnumber for validity
     */
    func isValidChairNumber(chairNumber: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.chairNumberRegex, options: [])
        if (regex.firstMatch(in: chairNumber, options: [], range: NSMakeRange(0, chairNumber.utf16.count)) != nil) {
            return true
        } else {
            return false
        }
    }
}

extension PopupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
