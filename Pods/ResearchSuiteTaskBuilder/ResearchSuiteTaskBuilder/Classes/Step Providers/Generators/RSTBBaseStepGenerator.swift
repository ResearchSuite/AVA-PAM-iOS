//
//  RSTBBaseStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

public protocol RSTBBaseStepGenerator: RSTBStepGenerator {
    var supportedTypes: [String]! {get}
}

public extension RSTBBaseStepGenerator {
    public func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    public func supportedStepTypes() -> [String] {
        return self.supportedTypes
    }
    
    public func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        return nil
    }
    
    func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [ORKStep]? {
        let step = self.generateStep(type: type, jsonObject: jsonObject, helper: helper)
        return step == nil ? [] : [step!]
    }
    
    func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        
        let splicedJSON: JSON = {
            if identifierPrefix == "" {
                return jsonObject
            }
            else {
                if let identifier: String = "identifier" <~~ jsonObject {
                    var newJSON = jsonObject
                    newJSON["identifier"] = "\(identifierPrefix).\(identifier)"
                    return newJSON
                }
                else {
                    return jsonObject
                }
            }
        }()

        return self.generateSteps(type: type, jsonObject: splicedJSON, helper: helper)
    }
}

