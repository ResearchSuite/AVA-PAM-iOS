//
//  ORBEDefaultTransformer.swift
//
//  Created by James Kizer on 1/30/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient
import ResearchSuiteResultsProcessor

open class ORBEDefaultTransformer: ORBEIntermediateDatapointTransformer {
    
    open static func transform(intermediateResult: RSRPIntermediateResult) -> OMHDataPoint? {
        
        guard let ohmDatapoint = intermediateResult as? OMHDataPoint else {
            return nil
        }
        
        return ohmDatapoint
    }

}
