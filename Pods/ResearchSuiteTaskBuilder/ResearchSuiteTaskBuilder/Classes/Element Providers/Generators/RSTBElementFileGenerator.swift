//
//  RSTBElementFileGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementFileGenerator: RSTBBaseElementGenerator {
    public init(){}
    
    let _supportedTypes = [
        "elementFile"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateElements(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [JSON]? {
        
        guard let descriptor = RSTBElementFileDescriptor(json: jsonObject),
            let jsonElement = helper.getJson(forFilename: descriptor.elementFilename) as? JSON else {
                return nil
        }
        
        return [jsonElement]
    }
}
