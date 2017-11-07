//
//  RSTBParticipantConsentSignatureGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBParticipantConsentSignatureGenerator: RSTBConsentSignatureGenerator {
    open class func supportsType(type: String) -> Bool {
        return "participantConsentSignature" == type
    }
    
    open class func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentSignature? {
        guard let desciptor = RSTBConsentSignatureDescriptor(json: jsonObject) else {
            return nil
        }
        
        return ORKConsentSignature(forPersonWithTitle: desciptor.title, dateFormatString: desciptor.dateFormatString, identifier: desciptor.identifier)
    }
}
