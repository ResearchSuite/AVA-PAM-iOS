//
//  RSTBInstructionStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBInstructionStepGenerator: RSTBBaseStepGenerator {
    public init(){}
    
    let _supportedTypes = [
        "instruction"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let element = RSTBInstructionStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let step = ORKInstructionStep(identifier: element.identifier)
        step.title = element.title
        step.text = element.text
        step.detailText = element.detailText
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
}
