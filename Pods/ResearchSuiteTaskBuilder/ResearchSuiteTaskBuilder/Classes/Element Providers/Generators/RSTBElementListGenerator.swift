//
//  RSTBElementListGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementListGenerator: RSTBBaseElementGenerator {
    public init(){}
    
    let _supportedTypes = [
        "elementList"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateElements(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [JSON]? {
        
        guard let descriptor = RSTBElementListDescriptor(json: jsonObject) else {
            return nil
        }
        
        let shuffledElements = descriptor.elementList.shuffled(shouldShuffle: descriptor.shuffled)
        
        return shuffledElements
    }
}
