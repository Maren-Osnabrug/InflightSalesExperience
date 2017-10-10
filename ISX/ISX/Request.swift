//
//  Request.swift
//  ISX
//
//  Created by Maren Osnabrug on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Request {
    
    let id: Int
    let productId: Int
    let customerChair: String
    var completed: Bool
    let ref: DatabaseReference?
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:AnyObject]
        self.id = dict["id"] as! Int
        self.productId = dict["product"] as! Int
        self.customerChair = dict["customerChair"] as! String
        self.completed = (dict["completed"] as! Int == 1 ? true : false)
        self.ref = snapshot.ref
    }
    
//    init(snapshot: DataSnapshot) {
//        print("init with ", snapshot)
//        self.id = snapshot.id
//        self.product = snapshot.product
//        self.customerChair = snapshot.customerChair
//    }
}


