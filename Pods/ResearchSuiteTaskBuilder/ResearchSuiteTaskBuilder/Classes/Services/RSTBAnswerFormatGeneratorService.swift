//
//  RSTBAnswerFormatGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBAnswerFormatGeneratorService: NSObject {
    
    static fileprivate var _service: RSTBAnswerFormatGeneratorService = RSTBAnswerFormatGeneratorService()
    static open var service: RSTBAnswerFormatGeneratorService {
        return _service
    }
    
    static open func initialize(services: [RSTBAnswerFormatGenerator]) {
        
        self._service = RSTBAnswerFormatGeneratorService(services: services)
    }
    
    fileprivate var loader: RSTBServiceLoader<RSTBAnswerFormatGenerator>!
    
    public convenience override init() {
        let services:[RSTBAnswerFormatGenerator] = []
        self.init(services: services)
    }
    
    public init(services: [RSTBAnswerFormatGenerator]) {
        let loader:RSTBServiceLoader<RSTBAnswerFormatGenerator> = RSTBServiceLoader()
        services.forEach({loader.addService(service: $0)})
        self.loader = loader
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        let generators = self.loader.iterator()
        
        for generator in generators {
            if generator.supportsType(type: type),
                let answerFormat = generator.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper) {
                return answerFormat
            }
        }
        
        return nil
        
    }
    
    open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        let generators = self.loader.iterator()
        
        for generator in generators {
            if generator.supportsType(type: type),
                let resultJson = generator.processQuestionResult(type: type, result: result, helper: helper) {
                return resultJson
            }
        }
        
        return nil
    }
    
}
