//
//  RequestDetail.swift
//  ISX
//
//  Created by Robby Michels on 21-12-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import FirebaseDatabase

class RequestDetail {
    let productId: String?
    let chairnumber: String?
    let deviceId: String!
    let requestDatabaseRef: DatabaseReference?
    let request: Request?
    
    init(productId: String, chairnumber: String, deviceId: String, requestDatabaseRef: DatabaseReference, request: Request) {
        self.productId = productId
        self.chairnumber = chairnumber
        self.deviceId = deviceId
        self.requestDatabaseRef = requestDatabaseRef
        self.request = request
    }
}
