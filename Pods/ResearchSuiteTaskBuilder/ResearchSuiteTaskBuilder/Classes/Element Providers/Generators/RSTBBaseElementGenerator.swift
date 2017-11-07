//
//  RSTBBaseElementGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

public protocol RSTBBaseElementGenerator: RSTBElementGenerator {
    
    var supportedTypes: [String]! {get}

}

extension RSTBBaseElementGenerator {
    public func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    public func supportedStepTypes() -> [String] {
        return self.supportedTypes
    }
}
