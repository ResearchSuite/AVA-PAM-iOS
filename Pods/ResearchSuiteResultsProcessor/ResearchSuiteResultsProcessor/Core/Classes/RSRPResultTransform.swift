//
//  RSRPResultTransform.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit
import Gloss

open class RSRPResultTransform: Decodable {
    
    open let transform: String!
    open let inputMapping: [RSRPResultTransformInputMapping]!
    
    required public init?(json: JSON) {
        
        guard let transform: String = "transform" <~~ json,
            let inputMapping: [RSRPResultTransformInputMapping] = "inputMapping" <~~ json else {
                return nil
        }
        self.transform = transform
        self.inputMapping = inputMapping
        
    }
    
}
