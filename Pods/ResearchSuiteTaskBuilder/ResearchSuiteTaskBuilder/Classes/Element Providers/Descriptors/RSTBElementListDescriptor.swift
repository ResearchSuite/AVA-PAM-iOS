//
//  RSTBElementListDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementListDescriptor: RSTBElementDescriptor {
    
    open let elementList: [JSON]!
    open let shuffled: Bool
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        guard let elementList: [JSON] = "elements" <~~ json
            else {
                return nil
        }
        
        self.elementList = elementList
        self.shuffled = "shuffleElements" <~~ json ?? false
        
        super.init(json: json)
    }

}
