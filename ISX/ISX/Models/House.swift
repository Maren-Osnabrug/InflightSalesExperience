//
//  House.swift
//  ISX
//
//  Created by Rosyl Budike on 19-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class House {

let category: String
let description: String
let id: String
let title: String
var image: UIImage?
let ref: DatabaseReference?

    init(category: String, description: String, id: String, title: String) {
        self.category = category
        self.description = description
        self.id = id
        self.title = title
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        category = snapshotValue["Category"] as! String
        description = snapshotValue["Description"] as! String
        id = snapshotValue["ID"] as! String
        title = (snapshotValue["Title"] as! String).capitalized
        image = UIImage(named: String(id)) == nil ? UIImage(named: "noImageAvailable") : UIImage(named: String(id))
        ref = snapshot.ref
    }
    
    func toAnyObject()-> Any {
        return [
            "Category": category,
            "Description": description,
            "ID": id,
            "Title": title
        ]
    }
}
