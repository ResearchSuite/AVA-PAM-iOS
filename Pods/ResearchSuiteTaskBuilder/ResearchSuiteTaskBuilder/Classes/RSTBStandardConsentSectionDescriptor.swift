//
//  RSTBStandardConsentSectionDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import Gloss
import ResearchKit

open class RSTBStandardConsentSectionDescriptor: RSTBElementDescriptor {
    
    open let sectionType: ORKConsentSectionType
    open let title: String?
    open let formalTitle: String?
    open let summary: String?
    open let content: String?
    open let htmlContent: String?
    open let contentURL: URL?
    open let omitFromDocument: Bool
    open let customImageTitle: String?
    open let customLearnMoreButtonTitle: String?
    open let customAnimationURL: URL?
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        guard let sectionTypeString: String = "sectionType" <~~ json,
            let sectionType = RSTBStandardConsentSectionDescriptor.sectionType(type: sectionTypeString) else {
                return nil
        }
        
        self.sectionType = sectionType
        self.title = "title" <~~ json
        self.formalTitle = "formalTitle" <~~ json
        self.summary = "summary" <~~ json
        self.content = "content" <~~ json
        self.htmlContent = "htmlContent" <~~ json
        self.contentURL = "contentURL" <~~ json
        self.omitFromDocument = "omitFromDocument" <~~ json ?? false
        self.customImageTitle = "customImageTitle" <~~ json
        self.customLearnMoreButtonTitle = "customLearnMoreButtonTitle" <~~ json
        self.customAnimationURL = "customAnimationURL" <~~ json
        
        super.init(json: json)
    }

    open class func sectionType(type: String) -> ORKConsentSectionType? {
        switch type {
        case "overview":
            return .overview
            
        case "dataGathering":
            return .dataGathering
            
        case "privacy":
            return .privacy
            
        case "dataUse":
            return .dataUse
            
        case "timeCommitment":
            return .timeCommitment
            
        case "studySurvey":
            return .studySurvey
            
        case "studyTasks":
            return .studyTasks
            
        case "withdrawing":
            return .withdrawing
            
        case "custom":
            return .custom
            
        case "onlyInDocument":
            return .onlyInDocument
            
        default:
            return nil
        }
    }
}
