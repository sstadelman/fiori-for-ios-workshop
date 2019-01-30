//
//  ReportIntentHandler.swift
//  TravelExpensesShared
//
//  Created by Stadelman, Stan on 1/7/19.
//  Copyright © 2019 SAP. All rights reserved.
//

import Foundation

public class AddExpenseIntentHandler: NSObject, AddExpenseIntentHandling {
    
    public func confirm(intent: AddExpenseIntent, completion: @escaping (AddExpenseIntentResponse) -> Void) {
        completion(AddExpenseIntentResponse(code: .ready, userActivity: nil))
    }
    
    public func handle(intent: AddExpenseIntent, completion: @escaping (AddExpenseIntentResponse) -> Void) {
        

        
        completion(AddExpenseIntentResponse(code: .addExpenseSuccess, userActivity: nil))
    }
    
    
}

public class ReportIntentHandler: NSObject, ReportIntentHandling {
    
    /// - Tag: confirm_intent
    public func confirm(intent: ReportIntent, completion: @escaping (ReportIntentResponse) -> Void) {
        //
        
        completion(ReportIntentResponse(code: .ready, userActivity: nil))
    }
  
    /// - Tag: handle_intent
    public func handle(intent: ReportIntent, completion: @escaping (ReportIntentResponse) -> Void) {
        //
        let report = ExpenseReportItem(withDefaults: true)
        let named = "New report"
        report.reportname = intent.named ?? named
        report.reportlocation = intent.location?.name
        DataHandler.shared.service.createEntity(report) { error in
            completion(.success(named: report.reportname!))
        }
    }
}
