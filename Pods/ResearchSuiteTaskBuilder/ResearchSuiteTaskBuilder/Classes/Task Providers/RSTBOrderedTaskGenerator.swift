//
//  RSTBOrderedTaskGenerator.swift
//  Pods
//
//  Created by James Kizer on 6/30/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBOrderedTaskGenerator: RSTBTaskGenerator {
    
    open static func supportsType(type: String) -> Bool {
        return type == "orderedTask"
    }
    open static func generateTask(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKTask? {
        
        guard let taskDescriptor = RSTBTaskDescriptor(json: jsonObject),
            let taskBuilder = helper.builder,
            let steps: [ORKStep] = taskBuilder.steps(forElement: taskDescriptor.rootStepElement as JsonElement) else {
            return nil
        }
        
        return ORKOrderedTask(identifier: taskDescriptor.identifier, steps: steps)
        
    }

}
