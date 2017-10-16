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
    
    init(id: Int, productId: Int, customerChair: String, completed: Bool) {
        self.id = id
        self.productId = productId
        self.completed = completed
        self.customerChair = customerChair
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:AnyObject]
        self.id = dict["id"] as! Int
        self.productId = dict["product"] as! Int
        self.customerChair = dict["customerChair"] as! String
        self.completed = (dict["completed"] as! Int == 1 ? true : false)
        self.ref = snapshot.ref
    }
    
    func toAnyObject()-> Any {
        return [
            "id": id,
            "product": productId,
            "completed": completed,
            "customerChair": customerChair
        ]
    }
}


