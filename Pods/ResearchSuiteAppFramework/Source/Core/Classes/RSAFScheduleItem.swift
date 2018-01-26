//
//  RSAFScheduleItem.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import Gloss
import ResearchSuiteResultsProcessor
import ResearchKit
import ReSwift

open class RSAFScheduleItem: Gloss.Decodable {
    open let type: String
    open let identifier: String
    open let title: String
    open let guid: String
    
    open let activity: JSON
    open let resultTransforms: [RSRPResultTransform]
    open var onCompletionActionCreators: [(UUID, RSAFActivityRun, ORKTaskResult?) -> Dispatchable<RSAFCombinedState>?]?
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        guard let type: String = "type" <~~ json,
            let identifier: String = "identifier" <~~ json,
            let title: String = "title" <~~ json,
            let guid: String = "guid" <~~ json,
            let activity: JSON = "activity" <~~ json else {
                return nil
        }
        self.type = type
        self.identifier = identifier
        self.title = title
        self.guid = guid
        
        self.activity = activity
        self.resultTransforms = {
            guard let resultTransforms: [JSON] = "resultTransforms" <~~ json else {
                return []
            }
            
            return resultTransforms.flatMap({ (transform) -> RSRPResultTransform? in
                return RSRPResultTransform(json: transform)
            })
        }()
        
    }

}
