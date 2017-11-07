//
//  CTFGoNoGoSummaryResultsGenerator.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import ResearchKit
import sdlrkx
import ResearchSuiteResultsProcessor

open class CTFGoNoGoSummaryResultsTransformer: RSRPFrontEndTransformer {

    open static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let goNoGoResult = parameters["GoNoGoResult"]?.firstResult as? CTFGoNoGoResult else {
            return nil
        }
        
        guard let summary = CTFGoNoGoSummary(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID, result: goNoGoResult) else {
            return nil
        }
        
        summary.startDate = goNoGoResult.startDate
        summary.endDate = goNoGoResult.endDate
        
        return summary
    }
    
    fileprivate static let supportedTypes = [
        "GoNoGoSummary"
    ]
    
    open static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
}
