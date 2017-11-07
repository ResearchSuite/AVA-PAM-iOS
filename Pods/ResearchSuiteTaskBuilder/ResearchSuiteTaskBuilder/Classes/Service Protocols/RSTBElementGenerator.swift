//
//  RSTBElementGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

public protocol RSTBElementGenerator {
    
    func generateElements(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [JSON]?
    func supportsType(type: String) -> Bool
    func supportedStepTypes() -> [String]

}
