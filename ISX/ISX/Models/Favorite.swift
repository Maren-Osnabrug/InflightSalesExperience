//
//  Favorite.swift
//  ISX
//
//  Created by Robby Michels on 08-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Favorite {
    let title: String!
    let id: String!
    let ref: DatabaseReference
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = (snapshotValue["Product_name_Holland_Herald_WBC_iPad"] as! String).capitalized
        id = snapshotValue["sku"] as! String
        self.ref = snapshot.ref
    }
    
}
