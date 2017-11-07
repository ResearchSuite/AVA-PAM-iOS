//
//  RSTBElementFileDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementFileDescriptor: RSTBElementDescriptor {
    
    open let elementFilename: String!
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        guard let elementFilename: String = "elementFileName" <~~ json
            else {
                return nil
        }
        
        self.elementFilename = elementFilename
        
        super.init(json: json)
    }

}
