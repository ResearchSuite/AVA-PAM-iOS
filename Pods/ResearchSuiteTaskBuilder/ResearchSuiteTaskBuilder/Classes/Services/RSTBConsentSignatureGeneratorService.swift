//
//  RSTBConsentSignatureGeneratorService.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import ResearchKit
import Gloss

class RSTBConsentSignatureGeneratorService: NSObject {

    let generators: [RSTBConsentSignatureGenerator.Type]
    
    public override convenience init() {
        let generators: [RSTBConsentSignatureGenerator.Type] = []
        self.init(generators: generators)
    }
    
    public init(generators: [RSTBConsentSignatureGenerator.Type]) {
        self.generators = generators
        super.init()
    }
    
    open func generate(type: String,
                         jsonObject: JSON,
                         helper:RSTBTaskBuilderHelper) -> ORKConsentSignature? {
        return self.generators
            .filter { $0.supportsType(type: type) }
            .flatMap { $0.generate(type: type, jsonObject: jsonObject, helper: helper) }
            .first
    }
    
}
