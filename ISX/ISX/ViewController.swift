//
//  ViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 26-09-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import UIKit
import FirebaseDatabase

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


}

