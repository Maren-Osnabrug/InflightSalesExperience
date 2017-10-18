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

class LoginViewController:UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /*
     * Login function
     */
    
    @IBAction func loginAction(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            //Alert user that an error occurred because they didn't fill in the textfields
            let alertController = UIAlertController(title: "Error", message: "Please enter an email address and a password.", preferredStyle: .alert)
            let acknowledgedAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(acknowledgedAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if (error == nil) {
                    //Redirect to cabin crew flow
                    self.performSegue(withIdentifier: "loginSeque", sender: self)
                } else {
                    //Alert user that an error occurred and shows firebase error
                    let alertController = UIAlertController(title: "Error", message: "Incorrect email address or password.", preferredStyle: .alert)
                    let acknowledgedAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(acknowledgedAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
