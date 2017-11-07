//
//  RSTBConsentDocumentGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import ResearchKit
import Gloss

open class RSTBConsentDocumentGeneratorService: NSObject {
    
    let generators: [RSTBConsentDocumentGenerator.Type]
    
    public override convenience init() {
        let generators: [RSTBConsentDocumentGenerator.Type] = []
        self.init(generators: generators)
    }
    
    public init(generators: [RSTBConsentDocumentGenerator.Type]) {
        self.generators = generators
        super.init()
    }
    
    open func generate(type: String,
                             jsonObject: JSON,
                             helper:RSTBTaskBuilderHelper) -> ORKConsentDocument? {
        return self.generators
            .filter { $0.supportsType(type: type) }
            .flatMap { $0.generate(type: type, jsonObject: jsonObject, helper: helper) }
            .first
    }

}
