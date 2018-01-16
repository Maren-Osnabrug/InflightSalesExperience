//
//  Flight.swift
//  ISX
//
//  Created by Jasper Zwiers on 22-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Flight {
    
    let id: Int
    let destination: String
    let averageRevenue: Int
    let highestRevenue: Int
    let ref: DatabaseReference?
    
    init(id: Int, destination: String, averageRevenue: Int, highestRevenue: Int) {
        self.id = id
        self.destination = destination
        self.averageRevenue = averageRevenue
        self.highestRevenue = highestRevenue
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String:AnyObject]
        self.id = dict["id"] as! Int
        self.destination = dict["destination"] as! String
        self.averageRevenue = dict["averageRevenue"] as! Int
        self.highestRevenue = dict["highestRevenue"] as! Int
        self.ref = snapshot.ref
    }
    
    /*
     * For sending an object back to Firebase
     */
    func toAnyObject()-> Any {
        return [
            "id": id,
            "destination": destination,
            "averageRevenue": averageRevenue,
            "highestRevenue": highestRevenue
        ]
    }
}
