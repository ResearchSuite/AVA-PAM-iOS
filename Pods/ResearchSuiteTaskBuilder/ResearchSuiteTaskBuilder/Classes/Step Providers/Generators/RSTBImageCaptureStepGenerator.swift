//
//  RSTBImageCaptureStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 8/16/17.
//
//

import ResearchKit
import Gloss

open class RSTBImageCaptureStepGenerator: RSTBBaseStepGenerator {
    
    public init() {}
    
    open var supportedTypes: [String]! {
        return ["imageCapture"]
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSTBStepDescriptor(json: jsonObject)  else {
                return nil
        }
        
        let step =
            ORKImageCaptureStep(identifier: stepDescriptor.identifier)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        step.isOptional = stepDescriptor.optional
        
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON?{
        return nil
    }

}
