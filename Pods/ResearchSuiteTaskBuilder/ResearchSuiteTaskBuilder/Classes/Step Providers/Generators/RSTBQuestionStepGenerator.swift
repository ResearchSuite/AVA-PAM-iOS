//
//  RSTBQuestionStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBQuestionStepGenerator: RSTBBaseStepGenerator, RSTBAnswerFormatGenerator {
    
    public init() {}
    
    open var supportedTypes: [String]! {
        return nil
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        return nil
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper),
            let questionStepDescriptor = RSTBQuestionStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let questionStep = ORKQuestionStep(identifier: questionStepDescriptor.identifier, title: questionStepDescriptor.title, text: questionStepDescriptor.text, answer: answerFormat)
        
        questionStep.isOptional = questionStepDescriptor.optional
        return questionStep
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        
        guard let questionResult = result.firstResult as? ORKQuestionResult else {
            return nil
        }
        
        return self.processQuestionResult(type: type, result: questionResult, helper: helper)
    }
    
    open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
