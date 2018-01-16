//
//  GoogleAnalyticsHelper.swift
//  ISX
//
//  Created by Robby Michels on 01-11-17.
//  Copyright © 2017 Maren Osnabrug. All rights reserved.
//

import Foundation

class GoogleAnalyticsHelper {
    /*
     * For logging a visit to a screen
     */
    func googleAnalyticLogScreen(screen: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screen)
        
        guard let build = (GAIDictionaryBuilder.createScreenView().build() as NSDictionary) as? [AnyHashable: Any] else {
            return print("Couldnt build GAI DictionaryBuilder")
        }
        tracker?.send(build)
    }
    
    /*
     * For logging an action
     */
    func googleAnalyticLogAction(category: String, action: String, label: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIEventAction, value: action)
        
        guard let build = (GAIDictionaryBuilder.createEvent(withCategory: category, action: action,
                                                            label: label, value: nil).build() as NSDictionary) as? [AnyHashable: Any] else {
            return print("Couldn't build GAI DictionaryBuilder")
        }
        tracker?.send(build)
    }
}
