//
//  DatabaseViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation

import UIKit
import FirebaseDatabase

class DatabaseViewController: UIViewController {
    
    var productsArray = [Product]()
    var productGroupsArray = [AnyObject]()
    var datarootRef : DatabaseReference?
    var productGroupsRef: DatabaseReference?
    var productsRef: DatabaseReference?
    
//    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Database.database().isPersistenceEnabled = true
        
        self.datarootRef = Database.database().reference(withPath: "dataroot")
        self.productGroupsRef = datarootRef?.child("productGroups")
        self.productsRef = datarootRef?.child("products")
        
        productsRef?.keepSynced(true)
        productGroupsRef?.keepSynced(true)
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
//                self.textView.text = "Connected"
                self.productsRef?.observe(.value, with: { snapshot in
                    for (index, item) in snapshot.children.enumerated() {
                        if let product = item as? DataSnapshot {
                            let modelProduct = Product.init(snapshot: product)
//                            self.textView.text = self.textView.text + "\n" + String(index) + "\t" +  modelProduct.title
                        }
                    }
                })
                self.productGroupsRef?.observe(.value, with: { snapshot in
                    for item in snapshot.children {
                        let fu  = (item as! DataSnapshot).value as? [String:AnyObject]
//                        self.textView.text = self.textView.text + "\n" + "\t" +  (fu!["Product_groep"] as! String)
                    }
                })
            } else {
                print("Not connected")
//                self.textView.text = "Not Connected"
                self.productsRef?.observe(.childAdded, with: { snapshot in
                    let modelProduct = Product.init(snapshot: snapshot)
//                    self.textView.text = self.textView.text + "\n" +  modelProduct.title
                })
                self.productGroupsRef?.observe(.childAdded, with: { snapshot in
                    for item in snapshot.children {
                        if let fu  = (item as! DataSnapshot).value as? [String:AnyObject] {
//                            self.textView.text = self.textView.text + "\n" + "\t" +  (fu["Product_groep"] as! String)
                        }
                    }
                })
            }
        })
    }
}


//    var productsArray = [Product]()
//    var productGroupsArray = [AnyObject]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        Database.database().isPersistenceEnabled = true
//        let datarootRef = Database.database().reference(withPath: "dataroot")
//        let productGroupsRef = datarootRef.child("productGroups")
//        let productsRef = datarootRef.child("products")
//        productsRef.keepSynced(true)
//        productGroupsRef.keepSynced(true)
//
//        let connectedRef = Database.database().reference(withPath: ".info/connected")
//        connectedRef.observe(.value, with: { snapshot in
//            if snapshot.value as? Bool ?? false {
//                print("Connected")
//            } else {
//                print("Not connected")
//            }
//        })
//
//        productsRef.observe(.value, with: { snapshot in
//            for item in snapshot.children {
//                if let product = item as? DataSnapshot {
//                    let modelProduct = Product.init(snapshot: product)
//                    print(modelProduct.title)
//                    self.productsArray.append(modelProduct)
//                }
//            }
//        })
//
//        productGroupsRef.observe(.value, with: { snapshot in
//            for item in snapshot.children {
//                self.productGroupsArray.append(item as AnyObject)
//                print(item)
//            }
//        })
//
//
//        //        datarootRef.observe(.value, with: { snapshot in
//        //            for item in snapshot.children {
//        //                let products = item as! DataSnapshot
//        //                let productAO = (products.value as! NSArray) as Array
//        //                for (product) in productAO.enumerated() {
//        //                    let modelProduct = Product.init(snapshotValue: product as AnyObject)
//        ////                    print(modelProduct.title)
//        //                    self.productsArray.append(modelProduct)
//        //                    print(self.productsArray.count)
//        //                }
//        //            }
//        //        })
//        //        print("total", self.productsArray.count)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        print(self.productsArray, self.productGroupsArray)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}

