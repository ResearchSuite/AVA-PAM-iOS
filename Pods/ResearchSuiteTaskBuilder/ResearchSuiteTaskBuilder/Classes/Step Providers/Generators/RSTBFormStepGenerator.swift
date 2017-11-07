//
//  RSTBFormStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBFormStepGenerator: RSTBBaseStepGenerator {
    
    open var supportedTypes: [String]! {
        return ["form"]
    }
    
    public init(){}
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let formStepDescriptor = RSTBFormStepDescriptor(json: jsonObject),
            let builder = helper.builder else {
                return nil
        }
        
        
        //generate form items from question step descriptors
        let formItems = formStepDescriptor.items.flatMap { (itemJson) -> ORKFormItem? in
            
            guard let stepDescriptor = RSTBStepDescriptor(json: itemJson) else {
                return nil
            }
            
            switch (stepDescriptor.type) {
            case "sectionTitle":
                return ORKFormItem(sectionTitle: stepDescriptor.title)
            default:
                let answerFormat = builder.generateAnswerFormat(type: stepDescriptor.type, jsonObject: itemJson, helper: helper)
                return ORKFormItem(identifier: stepDescriptor.identifier, text: stepDescriptor.text, answerFormat: answerFormat, optional: stepDescriptor.optional)
            }
            
        }
        
        let formStep = ORKFormStep(identifier: formStepDescriptor.identifier, title: formStepDescriptor.title, text: formStepDescriptor.text)
        formStep.formItems = formItems
        return formStep
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        
        
        guard let formStepDescriptor = RSTBFormStepDescriptor(json: jsonObject),
            let builder = helper.builder,
            let results = result.results as? [ORKQuestionResult] else {
                return nil
        }
        
        var resultsMap: [String: ORKQuestionResult] = [:]
        
        results.forEach { (questionResult) in
            resultsMap[questionResult.identifier] = questionResult
        }
        
        
        let formItemResults = formStepDescriptor.items.flatMap { (itemJson) -> JSON? in
            
            guard let stepDescriptor = RSTBStepDescriptor(json: itemJson) else {
                return nil
            }
            
            switch (stepDescriptor.type) {
            case "sectionTitle":
                return nil
            default:
                guard let result = resultsMap[stepDescriptor.identifier] else {
                    return nil
                }
                
                return builder.processQuestionResult(type: stepDescriptor.type, result: result, helper: helper)
            }
            
        }
        
        return [
            "identifier": result.identifier,
            "results": formItemResults
        ]
    }
    
}
