//
//  CTFOhmageRedirectLoginStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss
import ResearchSuiteExtensions

open class CTFOhmageRedirectLoginStepGenerator: RSRedirectStepGenerator {
    let _supportedTypes = [
        "OhmageOMHRedirectLogin"
    ]
    
    open override var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open override func getDelegate(helper: RSTBTaskBuilderHelper) -> RSRedirectStepDelegate? {
        
        guard let ohmageProvider = helper.stateHelper as? OhmageManagerProvider else {
                return nil
        }
        
        return ohmageProvider.getOhmageManager()
    }
    
}
