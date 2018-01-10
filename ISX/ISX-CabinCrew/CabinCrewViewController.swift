//
//  CabinCrewViewController.swift
//  ISX
//
//  Created by Maren Osnabrug on 04-10-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import UserNotifications
import NVActivityIndicatorView

class CabinCrewViewController: UITableViewController {
    var requestsArray = [Request]()
    var flightsArray = [Flight]()
    var productsArray = [Product]()
    private var initialLoad: Bool = false
    private var datarootRef: DatabaseReference?
    private var requestsRef: DatabaseReference?
    private var productsRef: DatabaseReference?
    private var flightsRef: DatabaseReference?
    var activityIndicatorView: NVActivityIndicatorView?
    private var selectedRequest: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupReferences()
        tableView.dataSource = self
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        activityIndicatorView = NVActivityIndicatorView(frame: view.frame, type: .ballSpinFadeLoader, color: Constants.spinnerGrey, padding: Constants.indicatorPadding)
        tableView.addSubview(activityIndicatorView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupReferences() {
        requestsRef = Constants.getRequestRef()
        requestsRef?.keepSynced(Constants.isFirebaseSynced())
        productsRef = Constants.getProductRef()
        flightsRef = Constants.getFlightsRef()
        
        observeRequests()
    }
    
    func observeRequests() {
        requestsArray = []
        activityIndicatorView?.startAnimating()
        requestsRef?.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let itemSnapshot = item as? DataSnapshot {
                    let toAdd = Request(snapshot: itemSnapshot )
                    if (!self.requestsArray.contains { $0.id == toAdd.id }) {
                        self.requestsArray.append(toAdd)
                        self.requestsArray.sort { !$0.completed && $1.completed }
                    }
                }
            }
            self.observeNewRequest()
        })
    }
    
    func observeNewRequest() {
        requestsRef?.queryLimited(toLast: 1).observe(.childAdded, with: { snapshot in
            let latestRequest = Request(snapshot: snapshot)
            let customerChair = latestRequest.customerChair
            self.checkAuthStatusProceed(customerChair)
            self.observeFlights()
        })
    }
    
    func checkAuthStatusProceed(_ customerChair: String) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    self.scheduleLocalNotification(customerChair)
                })
            case .authorized:
                self.scheduleLocalNotification(customerChair)
            case .denied:
                return
            }
        }
    }
    
    private func scheduleLocalNotification(_ customerChair: String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Inflight Sales Order"
        notificationContent.body = "A passenger ordered a product on seat: \(customerChair)"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest)
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            completionHandler(success)
        }
    }
    
    /*
     Returns array with flights
     */
    func observeFlights() {
        flightsRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let flightSnapshot = item as? DataSnapshot {
                    let flight = Flight(snapshot: flightSnapshot)
                    self.flightsArray.append(flight)
                }
            }
            self.observeProducts()
        })
    }
    
    /*
     Returns array with products
    */
    func observeProducts() {
        productsArray = []
        productsRef?.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if let productSnapshot = item as? DataSnapshot {
                    let product = Product(snapshot: productSnapshot)
                    self.productsArray.append(product)
                }
            }
            self.activityIndicatorView?.stopAnimating()
            self.tableView.reloadData()
            self.initialLoad = true
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.progressBarCellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let progressBarCell = tableView.dequeueReusableCell(withIdentifier: Constants.progressbarCell) as? ProgressBarCell
            else { return UITableViewCell() }
        if (flightsArray.count > 0 ) {
            let flight = flightsArray[1]
            var currentRevenue = Int()
            for request in requestsArray {
                if let found = productsArray.first(where: { $0.id.elementsEqual(String(request.productId)) && request.completed == true}) {
                    currentRevenue += found.retailPrice
                }
            }
            progressBarCell.setProgressBar(flight: flight, currentRevenue: currentRevenue)
            progressBarCell.isUserInteractionEnabled = false
        }
        return progressBarCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.requestCellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CCRequestCell, for: indexPath) as? RequestCell else { return UITableViewCell() }
        let request = requestsArray[indexPath.row]
        cell.setCellData(request: request)
        
        for item in productsArray {
            if (item.id == String(request.productId)) {
                cell.productName.text = item.title
            }
        }
        return cell
    }
    
    //Selected request will be loaded in the next screen.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRequest = requestsArray[indexPath.row]
        performSegue(withIdentifier: Constants.cabincrewToProductDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == Constants.cabincrewToProductDetail {
            if let nextViewController = segue.destination as? RequestDetailViewController {
                guard let productID = self.selectedRequest?.productId else { return }
                guard let chairNumber = self.selectedRequest?.customerChair else { return }
                guard let deviceID = self.selectedRequest?.deviceID else { return }
                guard let requestDatabaseRef = self.selectedRequest?.ref else { return }
                guard let request = self.selectedRequest else { return }
                nextViewController.requestDetail = RequestDetail(productId: String(productID), chairnumber: chairNumber, deviceId: deviceID, requestDatabaseRef: requestDatabaseRef, request: request)
            }
        }
    }
    
    //Reload the page, after being away from it, or changed pages.
    override func viewDidAppear(_ animated: Bool) {
        if(initialLoad) {
            observeRequests()
        }
    }
}
