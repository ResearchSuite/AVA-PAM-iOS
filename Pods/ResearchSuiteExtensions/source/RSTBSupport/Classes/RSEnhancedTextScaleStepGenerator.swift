//
//  RSEnhancedTextScaleStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedTextScaleStepGenerator: RSTBBaseStepGenerator {
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedTextScale"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateChoices(items: [RSTBChoiceItemDescriptor]) -> [ORKTextChoice] {
        
        return items.map { item in
            
            return ORKTextChoice(
                text: item.text,
                detailText: item.detailText,
                value: item.value,
                exclusive: item.exclusive)
        }
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        guard let stepDescriptor = RSEnhancedTextScaleStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let choices = self.generateChoices(items: stepDescriptor.items)
        
        guard choices.count > 0 else {
            return nil
        }
        
        
        let answerFormat = RSEnhancedTextScaleAnswerFormat(
            textChoices: choices,
            defaultIndex: stepDescriptor.defaultIndex,
            vertical: stepDescriptor.vertical,
            maxValueLabel: stepDescriptor.maximumValueLabel,
            minValueLabel: stepDescriptor.minimumValueLabel,
            maximumValueDescription: stepDescriptor.maximumValueDescription,
            neutralValueDescription: stepDescriptor.neutralValueDescription,
            minimumValueDescription: stepDescriptor.minimumValueDescription
        )
        
        return answerFormat
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper) as? RSEnhancedTextScaleAnswerFormat,
            let stepDescriptor = RSEnhancedTextScaleStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedTextScaleStep(identifier: identifier, answerFormat: answerFormat)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        
        if let stateHelper = helper.stateHelper,
            let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let stateHelper = helper.stateHelper,
            let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }

}
