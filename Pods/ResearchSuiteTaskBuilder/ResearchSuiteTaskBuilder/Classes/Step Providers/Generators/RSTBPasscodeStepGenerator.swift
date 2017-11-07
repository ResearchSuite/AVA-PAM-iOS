//
//  RSTBPasscodeStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 3/27/17.
//
//

import UIKit
import ResearchKit
import Gloss

open class RSTBPasscodeStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "passcode"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let element = RSTBStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let passcodeStep = ORKPasscodeStep(identifier:element.identifier)
        return passcodeStep
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
