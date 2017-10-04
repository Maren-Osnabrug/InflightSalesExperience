//
//  HomeViewController.swift
//  ISX
//
//  Created by Rosyl Budike on 03-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

// Border bottom code
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionCollectionView: UICollectionView!
    
    // Array met "Onze suggesties" producten
    let imageArray = ["seiko", "airbus", "aigber", "bvlgari"]
    let textArray = ["Seiko Horloge \n€ 299", "KLM Airbus \n€ 14", "Aigber City bag \n€ 139", "Bvlgari Man in Black \n€ 60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Statusbar in het blauw
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().clipsToBounds = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        
        // Border bottom voor "Onze suggesties" label
        // suggestionLabel.layer.borderWidth = 1.0
        // suggestionLabel.layer.borderColor = UIColor.gray.cgColor
        suggestionLabel.addBottomBorderWithColor(color: UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0), width: 1)
        
        suggestionCollectionView.delegate = self
        suggestionCollectionView.dataSource = self
        
        // Tabbar items ongeselecteerde kleur
        UITabBar.appearance().unselectedItemTintColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        // Tabbar border top
        self.tabBarController?.tabBar.layer.borderWidth = 1
        self.tabBarController?.tabBar.layer.borderColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0).cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = suggestionCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomSuggestionProductsCell
        
        customCell.suggestionImage.image = UIImage(named: imageArray[indexPath.row])
        customCell.suggestionText.text = textArray[indexPath.row]
        
        customCell.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        customCell.suggestionViewText.backgroundColor = UIColor(red:0.05, green:0.65, blue:0.88, alpha:1.0)
        return customCell
    }
    
//    public func readData() {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            let user = User.init(username: username)
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
}
