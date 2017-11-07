//
//  RSTBStandardConsentSectionGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBStandardConsentSectionGenerator: RSTBConsentSectionGenerator {

    open class func supportsType(type: String) -> Bool {
        return "standardConsentSection" == type
    }
    
    open class func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentSection? {
        
        guard let descriptor = RSTBStandardConsentSectionDescriptor(json: jsonObject) else {
                return nil
        }

        let section = ORKConsentSection(type: descriptor.sectionType)
        
        if let title = descriptor.title {
            section.title = descriptor.title
        }
        
        section.formalTitle = descriptor.formalTitle
        section.summary = descriptor.summary
        section.content = descriptor.content
        section.htmlContent = descriptor.htmlContent
        section.contentURL = descriptor.contentURL
        section.omitFromDocument = descriptor.omitFromDocument
        if let imageTitle = descriptor.customImageTitle {
            section.customImage = UIImage(named: imageTitle)
        }
        section.customLearnMoreButtonTitle = descriptor.customLearnMoreButtonTitle
        section.customAnimationURL = descriptor.customAnimationURL
        
        return section
        
    }

    
}
