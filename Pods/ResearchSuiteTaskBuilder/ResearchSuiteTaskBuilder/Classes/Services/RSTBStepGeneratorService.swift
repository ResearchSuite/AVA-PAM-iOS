//
//  RSTBStepGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBStepGeneratorService: NSObject {
    
    
    static fileprivate var _service: RSTBStepGeneratorService = RSTBStepGeneratorService()
    static open var service: RSTBStepGeneratorService {
        return _service
    }
    
    static open func initialize(services: [RSTBStepGenerator]) {
        
        self._service = RSTBStepGeneratorService(services: services)
    }
    
    fileprivate var loader: RSTBServiceLoader<RSTBStepGenerator>!
    
    public override convenience init() {
        let services:[RSTBStepGenerator] = []
        self.init(services: services)
    }
    
    public init(services: [RSTBStepGenerator]) {
        let loader:RSTBServiceLoader<RSTBStepGenerator> = RSTBServiceLoader()
        services.forEach({loader.addService(service: $0)})
        self.loader = loader
    }
    
    open func generateSteps(type: String,
                             jsonObject: JSON,
                             helper:RSTBTaskBuilderHelper,
                             identifierPrefix: String = "") -> [ORKStep]? {
        
        let stepGenerators = self.loader.iterator()
        
        for stepGenerator in stepGenerators {
            if stepGenerator.supportsType(type: type) {
                
                if let steps = stepGenerator.generateSteps(type: type, jsonObject: jsonObject, helper: helper, identifierPrefix: identifierPrefix) {
                    return steps
                }
                else if let steps = stepGenerator.generateSteps(type: type, jsonObject: jsonObject, helper: helper) {
                    return steps
                }
                else if let step = stepGenerator.generateStep(type: type, jsonObject: jsonObject, helper: helper) {
                    return [step]
                }
            }
        }
        
        return nil
        
    }
    
    @available(*, deprecated)
    open func processStepResult(type: String,
                                  jsonObject: JsonObject,
                                  result: ORKStepResult,
                                  helper: RSTBTaskBuilderHelper) -> JSON? {
        
        let stepGenerators = self.loader.iterator()
        
        for stepGenerator in stepGenerators {
            if stepGenerator.supportsType(type: type),
                let resultJSON = stepGenerator.processStepResult(type: type, jsonObject: jsonObject, result: result, helper: helper) {
                return resultJSON
            }
        }
        
        return nil
        
    }
}
