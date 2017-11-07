//
//  RSTBDatePickerStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBDatePickerStepGenerator: RSTBQuestionStepGenerator {
    
    override public init() {}
    
    override open var supportedTypes: [String]! {
        return ["datePicker"]
    }
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        return ORKAnswerFormat.dateAnswerFormat()
    }
    
    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        if let result = result as? ORKDateQuestionResult,
            let date = result.dateAnswer {
            return [
                "identifier": result.identifier,
                "type": type,
                "answer": GlossDateFormatterISO8601.string(from: date)
            ]
        }
        return  nil
    }

}
