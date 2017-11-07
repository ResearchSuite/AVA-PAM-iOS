//
//  RSTBInstructionStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBInstructionStepDescriptor: RSTBStepDescriptor {
    open let detailText: String?
    
    required public init?(json: JSON) {
        
        self.detailText = "detailText" <~~ json
        super.init(json: json)
        
    }
}
