//
//  RSTBElementGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBElementGeneratorService: NSObject {
    
    static fileprivate var _service: RSTBElementGeneratorService = RSTBElementGeneratorService()
    static open var service: RSTBElementGeneratorService {
        return _service
    }
    
    static open func initialize(services: [RSTBElementGenerator]) {
        
        self._service = RSTBElementGeneratorService(services: services)
    }
    
    fileprivate var loader: RSTBServiceLoader<RSTBElementGenerator>!
    
    public override convenience init() {
        let services:[RSTBElementGenerator] = []
        self.init(services: services)
    }
    
    public init(services: [RSTBElementGenerator]) {
        let loader:RSTBServiceLoader<RSTBElementGenerator> = RSTBServiceLoader()
        services.forEach({loader.addService(service: $0)})
        self.loader = loader
    }
    
    func supportsType(type: String) -> Bool {
        let stepGenerators = self.loader.iterator()
        
        for elementGenerator in stepGenerators {
            if elementGenerator.supportsType(type: type) {
                return true
            }
        }
        
        return false
    }
    
    func generateElements(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [JSON]? {
        let stepGenerators = self.loader.iterator()
        
        for elementGenerator in stepGenerators {
            if elementGenerator.supportsType(type: type),
                let elements = elementGenerator.generateElements(type: type, jsonObject: jsonObject, helper: helper) {
                return elements
            }
        }
        
        return nil
    }
    
}
