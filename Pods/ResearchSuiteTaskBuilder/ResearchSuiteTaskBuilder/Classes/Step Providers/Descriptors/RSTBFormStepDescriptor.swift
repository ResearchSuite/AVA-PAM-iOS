//
//  RSTBFormStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBFormStepDescriptor: RSTBStepDescriptor {
    
    open let items: [JSON]
    
    public required init?(json: JSON) {
        
        guard let items: [JSON] = "items" <~~ json else {
            return nil
        }
        
        self.items = items
        super.init(json: json)
        
    }
    
}
