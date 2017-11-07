//
//  YADLSpotDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/2/17.
//
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder

open class YADLSpotDescriptor: RSTBStepDescriptor {
    
    open let filterKey: String?
    open let items: [YADLItem]
    
    required public init?(json: JSON) {
        
        guard let items: [JSON] = "items" <~~ json else {
                return nil
        }

        self.items = items.flatMap({YADLItem(json: $0)})
        self.filterKey = "filterKey" <~~ json
        
        super.init(json: json)
    }
    
}
