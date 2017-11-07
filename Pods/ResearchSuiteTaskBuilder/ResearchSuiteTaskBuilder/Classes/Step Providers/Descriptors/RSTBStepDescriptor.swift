//
//  RSTBStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBStepDescriptor: RSTBElementDescriptor {
    
    open let optional: Bool
    open let title: String?
    open let text: String?
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        self.optional = "optional" <~~ json ?? true
        self.title = "title" <~~ json
        self.text = "text" <~~ json
        
        super.init(json: json)
        
    }
    
}
