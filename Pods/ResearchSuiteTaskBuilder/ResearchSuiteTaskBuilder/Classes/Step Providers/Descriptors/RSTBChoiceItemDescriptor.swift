//
//  RSTBChoiceItemDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import Gloss

open class RSTBChoiceItemDescriptor: Decodable {
    open let text: String
    open let detailText: String?
    open let value: NSCoding & NSCopying & NSObjectProtocol
    open let exclusive: Bool
    
    
    public required init?(json: JSON) {
        
        guard let prompt: String = "prompt" <~~ json,
            let value: NSCoding & NSCopying & NSObjectProtocol = "value" <~~ json
            else {
                return nil
        }
        
        
        self.text = prompt
        self.value = value
        self.detailText = "detailText" <~~ json
        self.exclusive = "exclusive" <~~ json ?? false
        
    }
}
