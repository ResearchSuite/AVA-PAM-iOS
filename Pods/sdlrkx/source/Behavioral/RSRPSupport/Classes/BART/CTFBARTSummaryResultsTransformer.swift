//
//  CTFBARTSummaryResultsGenerator.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit
import sdlrkx
import ResearchSuiteResultsProcessor

open class CTFBARTSummaryResultsTransformer: RSRPFrontEndTransformer {
    
    open static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let bartResult = parameters["BARTResult"]?.firstResult as? CTFBARTResult else {
            return nil
        }
        
        guard let summary = CTFBARTSummary(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID, result: bartResult) else {
            return nil
        }
        
        summary.startDate = bartResult.startDate
        summary.endDate = bartResult.endDate
        
        return summary
    }
    
    fileprivate static let supportedTypes = [
        "BARTSummary"
    ]
    
    open static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
}
