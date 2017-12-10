//
//  RequestFavoritesHolderCell.swift
//  ISX-CabinCrew
//
//  Created by Robby Michels on 29-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class RequestFavoritesHolderCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewFavorites: UITableView?
    var favoriteList = [Favorite]()
    private var datarootRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    private var favoritesRef: DatabaseReference?
    var deviceID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTable()
        setupDatabaseReferences()
    }
//
//    func setStyling() {
//
//    }
    
    func setupTable() {
        tableViewFavorites?.delegate = self
        tableViewFavorites?.dataSource = self
    }
    
    func setupDatabaseReferences() {
        datarootRef = Database.database().reference(withPath: Constants.firebaseDataroot)
        productsRef = datarootRef?.child(Constants.firebaseProductsTable)
        productsRef?.keepSynced(Constants.keepFirebaseSynced)
        favoritesRef = datarootRef?.child(Constants.firebaseFavoriteTable)
        favoritesRef?.keepSynced(Constants.keepFirebaseSynced)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesInRequestCell", for: indexPath) as? FavoritesInRequestCell {
            cell.setCellData(favorite: favoriteList[indexPath.row])
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //print(listWithUserFavorites[indexPath.row].title)
    }
    
    func getFavoritesFromUser() {
        print("GetfavoritesfromUSER---------------")
        let usersDeviceID = deviceID
        favoritesRef?.child(usersDeviceID!).observe(.value, with: { snapshot in
            for item in snapshot.children {
                let favoriteObject = Favorite(snapshot: item as! DataSnapshot)
                self.favoriteList.append(favoriteObject)
                print(favoriteObject)
            }
            self.tableViewFavorites?.reloadData()
        })
    }
}
