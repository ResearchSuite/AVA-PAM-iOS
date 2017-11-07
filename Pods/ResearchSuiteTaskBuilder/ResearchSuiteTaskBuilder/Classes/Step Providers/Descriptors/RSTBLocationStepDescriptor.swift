//
//  RSTBLocationStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 6/9/17.
//
//

import UIKit
import Gloss

open class RSTBLocationStepDescriptor: RSTBQuestionStepDescriptor {
    
    open let useCurrentLocation: Bool
    public required init?(json: JSON) {
        
        self.useCurrentLocation = "useCurrentLocation" <~~ json ?? true
        
        super.init(json: json)
        
    }

}
