//
//  CTFDelayDiscountingRawResultsTransformer.swift
//  ImpulsivityOhmage
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import sdlrkx
import ResearchKit
import ResearchSuiteResultsProcessor

open class CTFDelayDiscountingRawResultsTransformer: RSRPFrontEndTransformer {
    
    open static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let ddResult = parameters["DelayDiscountingResult"]?.firstResult as? CTFDelayDiscountingResult else {
            return nil
        }
        
        guard let summary = CTFDelayDiscountingRaw(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID, result: ddResult) else {
            return nil
        }
        
        summary.startDate = ddResult.startDate
        summary.endDate = ddResult.endDate
        
        return summary
    }
    
    fileprivate static let supportedTypes = [
        "DelayDiscountingRaw"
    ]
    
    open static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
}
