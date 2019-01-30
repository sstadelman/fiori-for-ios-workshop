//
//  IntentHandler.swift
//  TravelExpensesIntent
//
//  Created by Stadelman, Stan on 1/5/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Intents
import TravelExpensesShared

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is ReportIntent:
            return ReportIntentHandler()
        default:
            return ReportIntentHandler()
        }
        
        return self
    }
    
}
