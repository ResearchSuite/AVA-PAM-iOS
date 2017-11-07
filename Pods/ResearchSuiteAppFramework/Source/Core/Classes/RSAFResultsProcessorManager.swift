//
//  RSAFResultsProcessorManager.swift
//  Pods
//
//  Created by James Kizer on 3/25/17.
//
//

import UIKit
import ResearchSuiteResultsProcessor
import ReSwift
import ResearchKit

open class RSAFResultsProcessorManager: NSObject {

    let rsrp: RSRPResultsProcessor
    open class func frontEndTransformers() -> [RSRPFrontEndTransformer.Type] {
        return []
    }
    
    convenience init(backEnd: RSRPBackEnd) {
        
        self.init(backEnds: [backEnd])
        
    }
    
    init(backEnds: [RSRPBackEnd]) {
        
        self.rsrp = RSRPResultsProcessor(
            frontEndTransformers: RSAFResultsProcessorManager.frontEndTransformers(),
            backEnds: backEnds
        )
        
        super.init()
        
    }
    
    open func processResult(uuid: UUID, activityRun: RSAFActivityRun, taskResult: ORKTaskResult) {
        
        //process result
        if let resultTransforms = activityRun.resultTransforms {
            self.rsrp.processResult(taskResult: taskResult, resultTransforms: resultTransforms)
        }
        
    }

}
