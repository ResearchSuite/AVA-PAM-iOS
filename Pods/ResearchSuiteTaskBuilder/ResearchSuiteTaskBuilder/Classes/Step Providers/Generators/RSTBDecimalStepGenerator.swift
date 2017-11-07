//
//  RSTBDecimalStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import ResearchKit
import Gloss

open class RSTBDecimalStepGenerator: RSTBQuestionStepGenerator {

    override open var supportedTypes: [String]! {
        return ["numericDecimal"]
    }
    
    public override init(){}
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let descriptor = RSTBDecimalStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.decimalAnswerFormat(withUnit: descriptor.range?.unit)
        answerFormat.minimum = descriptor.range?.min as NSNumber?
        answerFormat.maximum = descriptor.range?.max as NSNumber?
        return answerFormat
    }
    
    override open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        
        return  nil
    }
    
}
