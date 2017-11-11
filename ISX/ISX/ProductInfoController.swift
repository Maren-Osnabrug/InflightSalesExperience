//
//  ProductInfoController.swift
//  ISX
//
//  Created by Robby Michels on 11-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ProductInfoController : UIViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var claimButton: UIButton!
    
    var addAlertSaveAction: UIAlertAction?
    var product: Product?
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    private var favoriteRef: DatabaseReference?
    var customerChair: String?

    private let unFavoriteImage = UIImage(named: "Heart")?.withRenderingMode(.alwaysTemplate)
    private let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)

    @IBAction func didClickFavoriteButton(_ sender: Any) {
        if let product = product {
            product.changeFavoriteStatus()
            updateFavoriteButton(favorite: product.favorite)
            handleFavoriteInFirebase(isFavorite: product.favorite)
        }
    }
    
    @IBAction func didClickRequestButton(_ sender: Any) {
        showInputDialog()
    }
    
    func showInputDialog() {
        let alertController = UIAlertController(title: "Enter your seatnumber", message: "Please enter your seat number so we can deliver your product.", preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            guard let customerChairNumber = alertController.textFields?.first?.text else {return}
            guard let product = self.product else { return }
            
            if(!self.errorCheckChairNumber(chairNumber: customerChairNumber)) {
                print("Error - Invalid chairnumber")
                return
            }

            self.requestsRef?.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                snapshot in
                var requestLatestId = 0
                for item in snapshot.children {
                    let req = Request.init(snapshot: item as! DataSnapshot)
                    requestLatestId = req.id
                }
                if let productId = Int(product.id) {
                    let requestForItem = Request(
                        id: requestLatestId + 1,
                        productId: productId,
                        customerChair: customerChairNumber,
                        completed: false
                    )
                    
                    let requestForItemRef = self.requestsRef?.childByAutoId()
                    requestForItemRef?.setValue(requestForItem.toAnyObject())
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }

        alertController.addTextField { (textField) in
            textField.placeholder = "example 1A"
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        alertController.actions[0].isEnabled = false
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product?.title
        //checkIfProductIsFavorited(productID: (product?.id)!)

        setupReferences()
        setupStyling()
    }
    
    func observeFavoriteStatus() {
        print("kngkjngkjngkjngkjng;lgl,gl,gl,gl,g")
        favoriteRef?.child(Constants.DEVICEID).child((product?.id)!)
        .observeSingleEvent(of: .value, with: { snapshot in
            print(self.product?.id)
            print(snapshot.value)
            print(snapshot.hasChildren())
            if snapshot.hasChildren() {
                print("ik kom bij true")
                self.updateFavoriteButton(favorite: true)
            }else {
                print("ik kom bij false")
                self.updateFavoriteButton(favorite: false)
            }
        })
//        product?.ref?.observeSingleEvent(of: .value, with: { snapshot in
//            if let data = snapshot.value as? [String: AnyObject] {
//                if let favoriteHasChanged = data["favorite"] as? Bool {
//                    self.product?.favorite = favoriteHasChanged
//                    self.updateFavoriteButton(favorite: favoriteHasChanged)
//                }
//            }
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStyling()
        observeFavoriteStatus()
    }
    
    func setupReferences() {
        datarootRef = Database.database().reference(withPath: "dataroot")
        requestsRef = datarootRef?.child("requests")
        favoriteRef = datarootRef?.child("favorite")
        requestsRef?.keepSynced(true)
    }
    
    func setupStyling() {
        guard let product = product else {
            return
        }
        productImageView.image = UIImage(named: "parfum")
        productTitleLabel.text = product.title
        priceLabel.text = "€" + String(product.retailPrice)
        descriptionTextView!.text = product.description
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        favoriteButton.tintColor = Constants.orange
        //updateFavoriteButton(favorite: product.favorite)
    }
    
    func updateFavoriteButton(favorite: Bool) {
        if (favorite) {
            favoriteButton.setImage(favoriteImage, for: .normal)
        } else {
            favoriteButton.setImage(unFavoriteImage, for: .normal)
        }
    }
    
    func errorCheckChairNumber(chairNumber: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.chairNumberRegex, options: [])
        if(regex.firstMatch(in: chairNumber, options: [], range: NSMakeRange(0, chairNumber.utf16.count)) != nil) {
            return true
        }else {
            return false
        }
    }
    
    @objc func textChanged(_ sender: Any) {
        guard let tf = sender as? UITextField else { return }
        var resp : UIResponder? = tf
        while !(resp is UIAlertController) { resp = resp?.next }
        guard let alert = resp as? UIAlertController else { return }
        if let chairNumber = tf.text {
            alert.actions[0].isEnabled = (errorCheckChairNumber(chairNumber: chairNumber))
        }
    }
    
    func handleFavoriteInFirebase(isFavorite: Bool) {
        if let productID = product?.id {
            if (isFavorite) {
                addFavoriteProduct(productID: productID)
            }else {
                deleteFavorite(productID: productID)
            }
        }else {
            print("couldn't cast productid to an integer, please make sure the id are only numbers.")
        }
    }
    
//    func checkIfProductIsFavorited(productID: String) {
//        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
//        favoriteRef?.child(Constants.DEVICEID).observe(.value, with: { snapshot in
//            print(snapshot.value)
//            print(snapshot.hasChildren())
//            if snapshot.hasChild(productID) {
//                self.product?.favorite = true
//            }else {
//                self.product?.favorite = false
//            }
//            //haal force wrap later weg
//            print("kdjbdkjbjdhbjdhbjdhb")
//            self.updateFavoriteButton(favorite: (self.product?.favorite)!)
//        })
////            .observeSingleEventofType(FIRDataEventType.Value, withBlock: { snapshot in
////                print(snapshot.hasChildren())
////                if snapshot.hasChildren() {
////                    self.product?.favorite = true
////                }else {
////                    self.product?.favorite = false
////                }
////                //haal force wrap later weg
////                self.updateFavoriteButton(favorite: (self.product?.favorite)!)
////            })
//        print("################################")
//    }
    
    func addFavoriteProduct(productID: String) {
        let pushObjectToFirebase = favoriteRef?.child(Constants.DEVICEID).child(String(productID))
        pushObjectToFirebase?.setValue(["productid": productID])
    }
    
    func deleteFavorite(productID: String) {
        favoriteRef?.child(Constants.DEVICEID).child(productID).removeValue()
    }
    
}
