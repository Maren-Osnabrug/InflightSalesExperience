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
    
    init(id: Int, productId: Int, customerChair: String, completed: Bool) {
        self.id = id
        self.productId = productId
        self.customerChair = customerChair
        self.completed = completed
    }
    
//    init(snapshot: DataSnapshot) {
//        print("init with ", snapshot)
//        self.id = snapshot.id
//        self.product = snapshot.product
//        self.customerChair = snapshot.customerChair
//    }
}


