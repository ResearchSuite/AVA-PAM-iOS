//
//  RSRPResultsProcessor.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit
import ResearchKit

open class RSRPResultsProcessor: NSObject {
    
    let frontEnd: RSRPFrontEndService
    let backEnds: [RSRPBackEnd]
    
    //keep for backwards compatibility
    public init(frontEndTransformers: [RSRPFrontEndTransformer.Type], backEnd: RSRPBackEnd) {
        self.frontEnd = RSRPFrontEndService(frontEndTransformers: frontEndTransformers)
        self.backEnds = [backEnd]
        super.init()
    }
    
    public init(frontEndTransformers: [RSRPFrontEndTransformer.Type], backEnds: [RSRPBackEnd]) {
        self.frontEnd = RSRPFrontEndService(frontEndTransformers: frontEndTransformers)
        self.backEnds = backEnds
        super.init()
    }
    
    open func processResult(taskResult: ORKTaskResult, resultTransforms: [RSRPResultTransform]) {
        let intermediateResults = self.frontEnd.processResult(taskResult: taskResult, resultTransforms: resultTransforms)
        let backEnds = self.backEnds
        backEnds.forEach { backEnd in
            intermediateResults.forEach { (intermediateResult) in
                backEnd.add(intermediateResult: intermediateResult)
            }
        }
        
    }

}
