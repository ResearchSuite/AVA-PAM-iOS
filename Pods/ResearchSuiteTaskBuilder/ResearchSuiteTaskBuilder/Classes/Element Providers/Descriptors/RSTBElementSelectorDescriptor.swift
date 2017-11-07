//
//  RSTBElementSelectorDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementSelectorDescriptor: RSTBElementDescriptor {
    open let elementList: [JSON]!
    open let selectorType: String!
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        guard let elementList: [JSON] = "elements" <~~ json,
            let selectorType: String = "selectorType" <~~ json
            else {
                return nil
        }
        
        self.elementList = elementList
        self.selectorType = selectorType
        
        super.init(json: json)
    }
}
