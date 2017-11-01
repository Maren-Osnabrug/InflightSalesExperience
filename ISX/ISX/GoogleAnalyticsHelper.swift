//
//  GoogleAnalyticsHelper.swift
//  ISX
//
//  Created by Robby Michels on 01-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation

class GoogleAnalyticsHelper {
    
    func googleAnalyticLogScreen (screen: String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screen)
        
        let build = (GAIDictionaryBuilder.createScreenView().build() as NSDictionary) as! [AnyHashable: Any]
        tracker?.send(build)
    }
    
    func googleAnalyticLogAction(category: String, action: String, label: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIEventAction, value: action)
        
        let build = (GAIDictionaryBuilder.createEvent(withCategory: category, action: action,
                                                      label: label, value: nil).build() as NSDictionary) as! [AnyHashable: Any]
        tracker?.send(build)
    }
}
