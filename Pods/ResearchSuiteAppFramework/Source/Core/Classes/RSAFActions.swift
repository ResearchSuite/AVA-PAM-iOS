//
//  RSAFActions.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ReSwift
import ResearchKit
import ResearchSuiteTaskBuilder
import ResearchSuiteResultsProcessor

struct SetLoggedInAction: Action {
    let loggedIn: Bool
}

struct QueueActivityAction: Action {
    let uuid: UUID
    let activityRun: RSAFActivityRun
    let taskBuilder: RSTBTaskBuilder
}

struct CompleteActivityAction: Action {
    let uuid: UUID
    let activityRun: RSAFActivityRun
    let taskResult: ORKTaskResult?
}

struct ResultsProcessedAction: Action {
    let uuid: UUID
}

struct SetValueInExtensibleStorage: Action {
    let key: String
    let value: NSObject?
}

struct ClearStore: Action {
    
}

struct Request: Action {
    
}

struct Response: Action {
    
}

struct SetTaskBuilder: Action {
    let taskBuilder: RSTBTaskBuilder?
}

struct SetResultsProcessor: Action {
    let resultsProcessor: RSRPResultsProcessor?
}

struct SetTitle: Action {
    let titleLabelText: String?
    let titleImage: UIImage?
}
