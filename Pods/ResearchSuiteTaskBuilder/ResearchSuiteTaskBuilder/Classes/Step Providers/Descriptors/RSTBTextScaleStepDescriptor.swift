//
//  RSTBTextScaleStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/24/17.
//
//

import UIKit
import Gloss

open class RSTBTextScaleStepDescriptor: RSTBQuestionStepDescriptor {
   
    open let items: [RSTBChoiceItemDescriptor]
    open let defaultIndex: Int
    open let vertical: Bool
    
    public required init?(json: JSON) {
        
        guard let items: [RSTBChoiceItemDescriptor] = "items" <~~ json else {
            return nil
        }
        
        self.items = items
        self.defaultIndex = "defaultIndex" <~~ json ?? -1
        self.vertical = "vertical" <~~ json ?? false
        super.init(json: json)
        
    }
    

}
