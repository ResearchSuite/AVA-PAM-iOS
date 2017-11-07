//
//  RSTBInvestigatorConsentSignatureGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBInvestigatorConsentSignatureGenerator: RSTBConsentSignatureGenerator {
    open class func supportsType(type: String) -> Bool {
        return "investigatorConsentSignature" == type
    }
    
    open class func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentSignature? {
        
        guard let desciptor = RSTBConsentSignatureDescriptor(json: jsonObject) else {
            return nil
        }
        
        let image: UIImage? = (desciptor.signatureImageTitle != nil) ? UIImage(named: desciptor.signatureImageTitle!) : nil
        
        return ORKConsentSignature(
            forPersonWithTitle: desciptor.title,
            dateFormatString: desciptor.dateFormatString,
            identifier: desciptor.identifier,
            givenName: desciptor.givenName,
            familyName: desciptor.familyName,
            signatureImage: image,
            dateString: desciptor.signatureDateString
        )
    }
}
