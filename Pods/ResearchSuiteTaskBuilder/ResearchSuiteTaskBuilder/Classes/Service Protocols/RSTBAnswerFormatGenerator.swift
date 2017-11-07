//
//  RSTBAnswerFormatGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

public protocol RSTBAnswerFormatGenerator {
    
    func supportsType(type: String) -> Bool
    func supportedStepTypes() -> [String]
    func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat?
    
    func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON?

}
