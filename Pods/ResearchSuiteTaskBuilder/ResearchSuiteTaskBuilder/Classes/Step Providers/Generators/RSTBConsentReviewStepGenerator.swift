//
//  RSTBConsentReviewStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/31/17.
//
//

import ResearchKit
import Gloss

open class RSTBConsentReviewStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "consentReview"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSTBConsentReviewStepDescriptor(json: jsonObject),
            let consentDocumentJSON = helper.getJson(forFilename: stepDescriptor.consentDocumentFilename) as? JSON,
            let consentDocType: String = "type" <~~ consentDocumentJSON,
            let consentDocument = helper.builder?.generateConsentDocument(type: consentDocType, jsonObject: consentDocumentJSON, helper: helper) else {
                return nil
        }
        
        guard let signature = consentDocument.signatures?.first else {
            return nil
        }
        
        let step = ORKConsentReviewStep(identifier: stepDescriptor.identifier, signature: signature, in: consentDocument)
        step.reasonForConsent = stepDescriptor.reasonForConsent
        
        return step
    }
    
    open func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
