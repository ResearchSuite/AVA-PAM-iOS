//
//  RSTBScaleStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/5/17.
//
//

import UIKit
import ResearchKit
import Gloss

open class RSTBScaleStepGenerator: RSTBQuestionStepGenerator {
    
    override open var supportedTypes: [String]! {
        return ["scale"]
    }
    
    public override init(){}
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let scaleDescriptor = RSTBScaleStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        return ORKAnswerFormat.scale(
            withMaximumValue: scaleDescriptor.maximumValue,
            minimumValue: scaleDescriptor.minimumValue,
            defaultValue: scaleDescriptor.defaultValue,
            step: scaleDescriptor.stepValue,
            vertical: scaleDescriptor.vertical,
            maximumValueDescription: scaleDescriptor.maximumDescription,
            minimumValueDescription: scaleDescriptor.minimumDescription
        )
    }
    
    override open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return  nil
    }

}
