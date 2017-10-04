//
//  ProductsFromCategoriesController.swift
//  ISX
//
//  Created by Robby Michels on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//
import Foundation
import UIKit

class ProductsFromCategoriesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var productsCollectionView: UICollectionView!
    var productArray = [String]()
    var productImageArray = [String]()
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 0
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: <#T##IndexPath#>)
            as! CustomCategoryCell
        cell.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.95, alpha:1.0)
        
        cell.categoryCellImage.image = UIImage(named: <#T##String#>)
        cell.categoryCellText.text = "Productnamen"
        return cell
    }

    
}
