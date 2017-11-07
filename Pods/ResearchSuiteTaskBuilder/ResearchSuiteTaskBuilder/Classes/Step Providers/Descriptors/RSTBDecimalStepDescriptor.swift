//
//  RSTBDecimalStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import Gloss

open class RSTBDecimalStepDescriptor: RSTBQuestionStepDescriptor {

    open class Range: Decodable {
        open let min: Double!
        open let max: Double!
        open let unit: String?
        
        public required init?(json: JSON) {
            
            self.min = "min" <~~ json ?? -Double.infinity
            self.max = "max" <~~ json ?? Double.infinity
            self.unit = "unitLabel" <~~ json
            
        }
    }
    
    open let range: Range?
    public required init?(json: JSON) {
        
        self.range = "range" <~~ json
        
        super.init(json: json)
        
    }
    
}
