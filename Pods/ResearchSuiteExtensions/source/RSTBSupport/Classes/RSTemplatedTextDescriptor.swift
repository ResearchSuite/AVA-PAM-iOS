//
//  RSTemplatedTextDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import Gloss

open class RSTemplatedTextDescriptor: Decodable {
    
    public let template: String
    public let arguments: [String]
    
    required public init?(json: JSON) {
        
        guard let template: String = "template" <~~ json else {
                return nil
        }
        
        self.template = template
        self.arguments = "arguments" <~~ json ?? []

    }

}
