//
//  CTFPAMMultipleRaw.swift
//  Pods
//
//  Created by James Kizer on 2/26/17.
//
//

import UIKit

import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor

open class CTFPAMMultipleRaw: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    static open let kType = "PAMMultipleRaw"
    
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
        
        return CTFPAMMultipleRaw(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            result: pamResult
        )
    }
    
    open let pamChoices: [[String: Any]]
    
    public init?(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        result: ORKChoiceQuestionResult
        ) {
        
        guard let choices = result.choiceAnswers as? [[String: Any]] else {
            return nil
        }
        
        self.pamChoices = choices
        
        super.init(
            type: CTFPAMMultipleRaw.kType,
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
    
}

