//
//  RSTBLocationStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 6/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBLocationStepGenerator: RSTBQuestionStepGenerator {
    
    override public init() {}
    
    override open var supportedTypes: [String]! {
        return ["location"]
    }
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let locationDescriptor = RSTBLocationStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.locationAnswerFormat()
        answerFormat.useCurrentLocation = locationDescriptor.useCurrentLocation
        return answerFormat
    }
    
    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return  nil
    }
    
}
