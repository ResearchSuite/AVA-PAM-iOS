//
//  RSTBTimePickerStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBTimePickerStepGenerator: RSTBQuestionStepGenerator {
    
    override public init() {}
    
    override open var supportedTypes: [String]! {
        return ["timePicker"]
    }
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        return ORKAnswerFormat.timeOfDayAnswerFormat()
    }
    
    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        if let result = result as? ORKTimeOfDayQuestionResult,
            let dateComponents = result.dateComponentsAnswer,
            let hour = dateComponents.hour,
            let minute = dateComponents.minute {
            return [
                "identifier": result.identifier,
                "type": type,
                "answer": [
                    "hour": hour,
                    "minute": minute
                ]
            ]
        }
        return  nil
    }

}
