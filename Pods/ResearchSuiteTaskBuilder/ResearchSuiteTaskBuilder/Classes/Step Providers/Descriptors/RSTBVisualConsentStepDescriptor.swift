//
//  RSTBVisualConsentStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/31/17.
//
//

import Gloss

open class RSTBVisualConsentStepDescriptor: RSTBStepDescriptor {
    
    open let consentDocumentFilename: String
    
    public required init?(json: JSON) {
        
        guard let consentDocumentFilename: String = "consentDocumentFilename" <~~ json else {
            return nil
        }
        
        self.consentDocumentFilename = consentDocumentFilename
        super.init(json: json)
        
    }

}
