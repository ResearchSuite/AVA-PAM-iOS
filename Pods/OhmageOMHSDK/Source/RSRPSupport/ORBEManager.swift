//
//  ORBEManager.swift
//
//  Created by James Kizer on 1/29/17.
//  Copyright © 2017 Foundry @ Cornell Tech. All rights reserved.
//

import UIKit
import OMHClient
import OhmageOMHSDK
import ResearchSuiteResultsProcessor

open class ORBEManager: RSRPBackEnd {
    
    let ohmageManager: OhmageOMHManager
    let transformers: [ORBEIntermediateDatapointTransformer.Type]
    open var metadata: [String: Any] = [:]
    
    public init(ohmageManager: OhmageOMHManager, transformers: [ORBEIntermediateDatapointTransformer.Type] = [ORBEDefaultTransformer.self], metadata: [String: Any]? = nil) {
        
        self.ohmageManager = ohmageManager
        self.transformers = transformers
        self.metadata = metadata ?? [:]
        
    }
    
    open func add(intermediateResult: RSRPIntermediateResult) {
        
        let metadata = self.metadata
        
        if var userInfo = intermediateResult.userInfo {
            metadata.forEach({ (pair) in
                userInfo[pair.0] = pair.1
            })
            
            intermediateResult.userInfo = userInfo
            
        }
        else {
            intermediateResult.userInfo = metadata
        }
        
        for transformer in self.transformers {
            if let datapoint: OMHDataPoint = transformer.transform(intermediateResult: intermediateResult) {
                
                
                
                //submit data point
                self.ohmageManager.addDatapoint(datapoint: datapoint) { (error) in
                    debugPrint(error)
                }
            }
        }
        
    }
    
}
