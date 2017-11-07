//
//  RSAFReduxState.swift
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

public final class RSAFCoreState: RSAFBaseState {

    let loggedIn: Bool
    
    public typealias ActivityQueueElement = (UUID, RSAFActivityRun, RSTBTaskBuilder)
    
    let activityQueue: [ActivityQueueElement]
//    let resultsQueue: [(UUID, RSAFActivityRun, ORKTaskResult)]
    let extensibleStorage: [String: NSObject]
    let taskBuilder: RSTBTaskBuilder?
    let resultsProcessor: RSRPResultsProcessor?
    let titleLabelText: String?
    let titleImage: UIImage?
    
    public init(loggedIn: Bool = false,
        activityQueue: [ActivityQueueElement] = [],
        resultsQueue: [(UUID, RSAFActivityRun, ORKTaskResult)] = [],
        extensibleStorage: [String: NSObject] = [:],
        taskBuilder: RSTBTaskBuilder? = nil,
        resultsProcessor: RSRPResultsProcessor? = nil,
        titleLabelText: String? = nil,
        titleImage: UIImage? = nil
        ) {
        
        self.loggedIn = loggedIn
        self.activityQueue = activityQueue
//        self.resultsQueue = resultsQueue
        self.extensibleStorage = extensibleStorage
        self.taskBuilder = taskBuilder
        self.resultsProcessor = resultsProcessor
        self.titleLabelText = titleLabelText
        self.titleImage = titleImage
        
        super.init()
        
    }
    
    public required override convenience init() {
        self.init(loggedIn: false)
    }

    
    static func newState(
        fromState: RSAFCoreState,
        loggedIn: Bool? = nil,
        activityQueue: [ActivityQueueElement]? = nil,
        resultsQueue: [(UUID, RSAFActivityRun, ORKTaskResult)]? = nil,
        extensibleStorage: [String: NSObject]? = nil,
        taskBuilder: (RSTBTaskBuilder?)? = nil,
        resultsProcessor: (RSRPResultsProcessor?)? = nil,
        titleLabelText: (String?)? = nil,
        titleImage: (UIImage?)? = nil
        ) -> RSAFCoreState {
        
        return RSAFCoreState(
            loggedIn: loggedIn ?? fromState.loggedIn,
            activityQueue: activityQueue ?? fromState.activityQueue,
//            resultsQueue: resultsQueue ?? fromState.resultsQueue,
            extensibleStorage: extensibleStorage ?? fromState.extensibleStorage,
            taskBuilder: taskBuilder ?? fromState.taskBuilder,
            resultsProcessor: resultsProcessor ?? fromState.resultsProcessor,
            titleLabelText: titleLabelText ?? fromState.titleLabelText,
            titleImage: titleImage ?? fromState.titleImage
        )
    }
    
    open override var description: String {
        return
            "\n\tloggedIn: \(self.loggedIn)" +
        "\n\tactivityQueue: \(self.activityQueue)" +
//        "\n\tresultsQueue: \(self.resultsQueue)"+
        "\n\textensibleStorage: \(self.extensibleStorage)"
    }
    
}
