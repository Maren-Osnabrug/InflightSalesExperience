//
//  LoginViewController.swift
//  ISX
//
//  Created by Jasper Zwiers on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import PopupDialog

class LoginViewController:UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.text = "cabin@crew.nl"
        passwordTextField.text = "cabincrew"
        navigationController?.isNavigationBarHidden = true
    }
    
    /*
     * Login for cabin crew.
     * User input gets checked, if input is correct, Home will be loaded up.
     * If input is wrong, user gets an error message.
     */
    @IBAction func loginAction(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            //Alert user if they didn't fill in the textfields
            let popup = PopupDialog(title: Constants.Popup.errorTitle, message: Constants.Popup.enterAccountDetails, buttonAlignment: .horizontal,
                                    transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
            let buttonOne = DefaultButton(title: Constants.Popup.understand) {}
            popup.addButton(buttonOne)
            present(popup, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if (error == nil) {
                    //Redirect to cabin crew
                    let crewRef = Constants.getCrewRef()
                    let crewMemberRef = crewRef.childByAutoId()
                    let key = "deviceID\(crewMemberRef.key)"
                    let crewMember = [InstanceID.instanceID().token()!:key]

                    crewRef.updateChildValues(crewMember)

                    self.performSegue(withIdentifier: Constants.loginToRequests, sender: self)
                } else {
                    //Alert user if account details are incorrect
                    let popup = PopupDialog(title: Constants.Popup.errorTitle, message: Constants.Popup.wrongAccountDetails, buttonAlignment: .horizontal,
                                            transitionStyle: .zoomIn, gestureDismissal: true, hideStatusBar: true)
                    let buttonOne = DefaultButton(title: Constants.Popup.understand) {}
                    popup.addButton(buttonOne)
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
    }
}
