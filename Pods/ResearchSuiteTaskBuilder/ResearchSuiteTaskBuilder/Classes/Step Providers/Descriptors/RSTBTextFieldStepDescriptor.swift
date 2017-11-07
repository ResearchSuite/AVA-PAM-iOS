//
//  RSTBTextFieldStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBTextFieldStepDescriptor: RSTBQuestionStepDescriptor {
    
    public enum TextType: String {
        case normal = "normal"
        case name = "name"
        case email = "email"
        case password = "password"
        case number = "number"
    }
    
    open let maximumLength: Int?
    open let multipleLines: Bool
    open let validationRegex: String?
    open let invalidMessage: String?
    open let textType: TextType
    
    required public init?(json: JSON) {
        
        self.maximumLength = "maximumLength" <~~ json
        self.multipleLines = "multipleLines" <~~ json ?? false
        self.validationRegex = "validationRegex" <~~ json
        self.invalidMessage = "invalidMessage" <~~ json
        self.textType = "textType" <~~ json ?? .normal
        super.init(json: json)
        
    }
}
