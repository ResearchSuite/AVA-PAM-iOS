//
//  RSTBTaskDescriptor.swift
//  Pods
//
//  Created by James Kizer on 6/30/17.
//
//

import UIKit
import Gloss

open class RSTBTaskDescriptor: RSTBElementDescriptor {
    
    open let rootStepElement: JSON
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        guard let rootStepElement: JSON = "rootStepElement" <~~ json else {
            return nil
        }
        
        self.rootStepElement = rootStepElement
        
        super.init(json: json)
        
    }

}
