//
//  RSRedirectStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import ResearchSuiteTaskBuilder
import Gloss

open class RSRedirectStepDescriptor: RSTBStepDescriptor {
    
    public let buttonText: String
    
    required public init?(json: JSON) {
        guard let buttonText: String = "buttonText" <~~ json else {
            return nil
        }
        self.buttonText = buttonText
        super.init(json: json)
    }

}
