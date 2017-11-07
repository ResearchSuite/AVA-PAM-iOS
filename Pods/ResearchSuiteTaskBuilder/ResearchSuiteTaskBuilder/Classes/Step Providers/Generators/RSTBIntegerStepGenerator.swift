//
//  RSTBIntegerStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBIntegerStepGenerator: RSTBQuestionStepGenerator {
    
    override open var supportedTypes: [String]! {
        return ["numericInteger"]
    }
    
    public override init(){}
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let itegerDescriptor = RSTBIntegerStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.integerAnswerFormat(withUnit: itegerDescriptor.range.unit)
        answerFormat.minimum = itegerDescriptor.range.min as NSNumber?
        answerFormat.maximum = itegerDescriptor.range.max as NSNumber?
        return answerFormat
    }
    
    override open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        
        if let result = result as? ORKNumericQuestionResult,
            let numericAnswer = result.numericAnswer {
            return [
                "identifier": result.identifier,
                "type": type,
                "answer": numericAnswer.intValue
            ]
        }
        return  nil
    }
    
}
