//
//  ViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 26-09-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    var rootRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = Database.database().reference()
        let productsRef = Database.database().reference(withPath: "dataroot")
        rootRef.observe(.value, with: { snapshot in
//            print(snapshot.value)
        })
        productsRef.observe(.value, with: { snapshot in
//            print("test", snapshot.value)
            
            for item in snapshot.children {
                let products = item
                print(type(of:products))
                print(products)
            }
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Login
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /*
     * Login function
     */
 
    @IBAction func loginAction(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Foutmelding", message: "Voer alstublieft een emailadres en wachtwoord in.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Oke", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    
                    //Should be a redirect to controller for cabin crew
//                    //Go to the HomeViewController if the login is sucessful
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Foutmelding", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Oke", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
    }
}

