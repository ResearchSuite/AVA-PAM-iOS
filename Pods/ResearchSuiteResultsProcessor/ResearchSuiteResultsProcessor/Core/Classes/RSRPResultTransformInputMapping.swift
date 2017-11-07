//
//  RSRPResultTransformInputMapping.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit
import Gloss

public enum RSRPResultTransformInputMappingType {
    case stepIdentifier
    case stepIdentifierRegex
    case constant
}

open class RSRPResultTransformInputMapping: Decodable {
    
    open let mappingType: RSRPResultTransformInputMappingType
    open let value: AnyObject
    open let parameter: String
    
    required public init?(json: JSON) {
        
        guard let parameter: String = "parameter" <~~ json else {
                return nil
        }
        
        self.parameter = parameter
        
        if let stepIdentifier: String = "stepIdentifier" <~~ json {
            self.mappingType = .stepIdentifier
            self.value = stepIdentifier as AnyObject
        }
        else if let value: AnyObject = "constant" <~~ json {
            self.mappingType = .constant
            self.value = value
        }
        else if let stepIdentifierRegex: String = "stepIdentifierRegex" <~~ json {
            self.mappingType = .stepIdentifierRegex
            self.value = stepIdentifierRegex as AnyObject
        }
        else {
            return nil
        }
        
    }

}
