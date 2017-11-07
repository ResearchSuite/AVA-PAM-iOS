//
//  RSTBConsentSignatureDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss

open class RSTBConsentSignatureDescriptor: RSTBElementDescriptor {
    
    open let title: String?
    open let dateFormatString: String?
    open let givenName: String?
    open let familyName: String?
    open let signatureImageTitle: String?
    open let signatureDateString: String?
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        self.title = "title" <~~ json
        self.dateFormatString = "dateFormatString" <~~ json
        self.givenName = "givenName" <~~ json
        self.familyName = "familyName" <~~ json
        self.signatureImageTitle = "signatureImageTitle" <~~ json
        self.signatureDateString = "signatureDateString" <~~ json
        
        super.init(json: json)
    }

}
