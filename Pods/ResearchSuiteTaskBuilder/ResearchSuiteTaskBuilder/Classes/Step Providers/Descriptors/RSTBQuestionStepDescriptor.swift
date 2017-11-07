//
//  RSTBQuestionStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBQuestionStepDescriptor: RSTBStepDescriptor {
    open let placeholder: String?
    
    required public init?(json: JSON) {
        
        self.placeholder = "placeholder" <~~ json
        super.init(json: json)
        
    }
}
