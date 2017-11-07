//
//  RSTBChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBChoiceStepDescriptor<ChoiceItem: RSTBChoiceItemDescriptor>: RSTBQuestionStepDescriptor {
    
    open let items: [ChoiceItem]
    open let valueSuffix: String?
    open let shuffleItems: Bool
    open let maximumNumberOfItems: Int?
    
    public required init?(json: JSON) {
        
        guard let items: [ChoiceItem] = "items" <~~ json else {
            return nil
        }
        
        self.items = items
        self.valueSuffix = "valueSuffix" <~~ json
        self.shuffleItems = "shuffleItems" <~~ json ?? false
        self.maximumNumberOfItems = "maximumNumberOfItems" <~~ json
        super.init(json: json)
        
    }
    
}
