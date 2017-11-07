//
//  CTFOhmageLoginStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 3/26/17.
//
//

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class CTFOhmageLoginStepGenerator: RSTBBaseStepGenerator {
    public init(){}
    
    let _supportedTypes = [
        "OhmageOMHLogin"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let ohmageProvider = helper.stateHelper as? OhmageManagerProvider else {
            return nil
        }
        
        let step = CTFOhmageLoginStep(
            identifier: customStepDescriptor.identifier,
            title: customStepDescriptor.title,
            text: customStepDescriptor.text,
            ohmageManager: ohmageProvider.getOhmageManager()
        )
        
        
        step.isOptional = false
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
}
