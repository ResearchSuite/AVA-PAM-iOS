//
//  CTFPAMRaw.swift
//  Pods
//
//  Created by James Kizer on 2/26/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor

open class CTFPAMRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    static open let kType = "PAMRaw"
    
    fileprivate static let supportedTypes = [
        kType
    ]
    
    open static func supportsType(type: String) -> Bool {
        return supportedTypes.contains(type)
    }
    
    open static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
        ) -> RSRPIntermediateResult? {
        
        guard let pamStepResult = parameters["result"] as? ORKStepResult,
            let pamResult = pamStepResult.results?.first as? ORKChoiceQuestionResult else {
                return nil
        }
        
        return CTFPAMRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            result: pamResult
        )
    }
    
    open let pamChoice: [String: Any]
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: ORKChoiceQuestionResult
        ) {
        
        guard let choice = result.choiceAnswers?.first as? [String: Any] else {
            return nil
        }
        
        self.pamChoice = choice
        
        super.init(
            type: CTFPAMRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }

}
