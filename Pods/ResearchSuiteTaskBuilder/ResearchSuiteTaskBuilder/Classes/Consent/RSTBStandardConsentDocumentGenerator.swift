//
//  RSTBStandardConsentDocumentGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBStandardConsentDocument: ORKConsentDocument, RSTBConsentDocumentGenerator {
    
    open static func supportsType(type: String) -> Bool {
        return type == "standardConsentDocument"
    }
    
    open static func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentDocument? {
        
        guard let descriptor = RSTBStandardConsentDocumentDescriptor(json: jsonObject),
            let taskBuilder = helper.builder else {
                return nil
        }
        
        let sections:[ORKConsentSection] = descriptor.sections.flatMap { sectionJSON in
            
            guard let type: String = "type" <~~ sectionJSON else {
                return nil
            }
            
            return taskBuilder.generateConsentSection(type: type, jsonObject: sectionJSON, helper: helper)
            
        }
        
        let signatures: [ORKConsentSignature] = descriptor.signatures.flatMap { signatureJSON in
            guard let type: String = "type" <~~ signatureJSON else {
                return nil
            }
            
            return taskBuilder.generateConsentSignature(type: type, jsonObject: signatureJSON, helper: helper)
        }
        
        return RSTBStandardConsentDocument(
            title: descriptor.title,
            sections: sections,
            signatures: signatures
        )
        
    }
    
    public init(
        title: String,
        sections: [ORKConsentSection],
        signatures: [ORKConsentSignature]
    ) {
        super.init()
        
        self.title = title
        self.sections = sections
        signatures.forEach { self.addSignature($0) }
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
