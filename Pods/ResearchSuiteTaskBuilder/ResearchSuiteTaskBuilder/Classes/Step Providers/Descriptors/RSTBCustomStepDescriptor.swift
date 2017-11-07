//
//  RSTBCustomStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBCustomStepDescriptor: RSTBStepDescriptor {
    
    open var parameters: JSON?
    open var parameterFileName: String?
    
    public required init?(json: JSON) {
        
        self.parameters = "parameters" <~~ json
        self.parameterFileName = "parameterFileName" <~~ json
        super.init(json: json)
        
    }
    
}
