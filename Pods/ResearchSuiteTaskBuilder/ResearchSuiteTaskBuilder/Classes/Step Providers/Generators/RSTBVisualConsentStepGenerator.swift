//
//  RSTBVisualConsentStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/31/17.
//
//

import ResearchKit
import Gloss

open class RSTBVisualConsentStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "visualConsent"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSTBVisualConsentStepDescriptor(json: jsonObject),
            let consentDocumentJSON = helper.getJson(forFilename: stepDescriptor.consentDocumentFilename) as? JSON,
            let consentDocType: String = "type" <~~ consentDocumentJSON,
            let consentDocument = helper.builder?.generateConsentDocument(type: consentDocType, jsonObject: consentDocumentJSON, helper: helper) else {
            return nil
        }
       
        return ORKVisualConsentStep(identifier: stepDescriptor.identifier, document: consentDocument)

    }
    
    open func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
