//
//  RSAFActivityRun.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchSuiteResultsProcessor
import ResearchKit
import ReSwift

public struct RSAFActivityRun {
    
    public let identifier: String
    let activity: JsonElement
    let resultTransforms: [RSRPResultTransform]?
    var onCompletionActionCreators: [(UUID, RSAFActivityRun, ORKTaskResult?) -> Dispatchable<RSAFCombinedState>?]?
    
    public init(identifier: String,
         activity: JsonElement,
         resultTransforms: [RSRPResultTransform]?,
         onCompletionActionCreators: [(UUID, RSAFActivityRun, ORKTaskResult?) -> Dispatchable<RSAFCombinedState>?]? = nil
        ) {
        
        self.identifier = identifier
        self.activity = activity
        self.resultTransforms = resultTransforms
        self.onCompletionActionCreators = onCompletionActionCreators
    }
    
    public static func create(from scheduleItem: RSAFScheduleItem) -> RSAFActivityRun {
        return RSAFActivityRun(
            identifier: scheduleItem.identifier,
            activity: scheduleItem.activity as JsonElement,
            resultTransforms: scheduleItem.resultTransforms,
            onCompletionActionCreators: scheduleItem.onCompletionActionCreators)
    }

}
