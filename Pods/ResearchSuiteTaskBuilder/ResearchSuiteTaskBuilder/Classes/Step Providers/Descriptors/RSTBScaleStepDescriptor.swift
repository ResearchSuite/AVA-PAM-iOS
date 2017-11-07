//
//  RSTBScaleStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/5/17.
//
//

import UIKit
import Gloss

open class RSTBScaleStepDescriptor: RSTBQuestionStepDescriptor {

    open let maximumValue: Int
    open let minimumValue: Int
    open let defaultValue: Int
    open let stepValue: Int
    open let vertical: Bool
    open let maximumDescription: String?
    open let minimumDescription: String?
    
    required public init?(json: JSON) {
        
        guard let maximumValue: Int = "maximumValue" <~~ json,
            let minimumValue: Int = "minimumValue" <~~ json,
            let defaultValue: Int = "defaultValue" <~~ json,
            let stepValue: Int = "stepValue" <~~ json else {
                return nil
        }
        
        self.maximumValue = maximumValue
        self.minimumValue = minimumValue
        self.defaultValue = defaultValue
        self.stepValue = stepValue
        self.vertical = "vertical" <~~ json ?? false
        self.maximumDescription = "maximumDescription" <~~ json
        self.minimumDescription = "minimumDescription" <~~ json
        super.init(json: json)
        
    }
    
}
