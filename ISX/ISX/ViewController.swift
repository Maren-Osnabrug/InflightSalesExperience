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
    var productsArray = [Product]()
    var productGroupsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let datarootRef = Database.database().reference(withPath: "dataroot")
        let productGroupsRef = datarootRef.child("productGroups")
        let productsRef = datarootRef.child("products")

        productsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let product = item as! DataSnapshot
                let modelProduct = Product.init(snapshot: product)
//                print(modelProduct.title)
                self.productsArray.append(modelProduct)
            }
        })
        
        productGroupsRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                self.productGroupsArray.append(item as AnyObject)
//                print(item)
            }
        })
        
        
//        datarootRef.observe(.value, with: { snapshot in
//            for item in snapshot.children {
//                let products = item as! DataSnapshot
//                let productAO = (products.value as! NSArray) as Array
//                for (product) in productAO.enumerated() {
//                    let modelProduct = Product.init(snapshotValue: product as AnyObject)
////                    print(modelProduct.title)
//                    self.productsArray.append(modelProduct)
//                    print(self.productsArray.count)
//                }
//            }
//        })
//        print("total", self.productsArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(self.productsArray, self.productGroupsArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
