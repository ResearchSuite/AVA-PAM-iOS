//
//  RSTBTaskGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 6/30/17.
//
//

import Foundation
import ResearchKit
import Gloss

open class RSTBTaskGeneratorService: NSObject {
    
    let taskGenerators: [RSTBTaskGenerator.Type]
    
    public override convenience init() {
        let taskGenerators: [RSTBTaskGenerator.Type] = []
        self.init(taskGenerators: taskGenerators)
    }
    
    public init(taskGenerators: [RSTBTaskGenerator.Type]) {
        self.taskGenerators = taskGenerators
        super.init()
    }
    
    open func generateTask(type: String,
                              jsonObject: JSON,
                              helper:RSTBTaskBuilderHelper) -> ORKTask? {
        return self.taskGenerators
            .flatMap { $0.generateTask(type: type, jsonObject: jsonObject, helper: helper) }
            .first
    }
    
}
