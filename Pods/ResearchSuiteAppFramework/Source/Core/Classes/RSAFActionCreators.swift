//
//  RSAFActionCreators.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ReSwift
import ResearchKit
import ResearchSuiteResultsProcessor
import ResearchSuiteTaskBuilder

//public protocol Dispatchable {
//    var dispatchObject: Any { get }
//    var callback: ((StateType) -> Void)? { get }
//}

public struct Dispatchable<State: StateType> {
    let object: Any
    let callback: ((State) -> Void)?
    
    init(object: Any, callback: ((State) -> Void)? = nil) {
        self.object = object
        self.callback = callback
    }
}

public extension Store where State: RSAFCombinedState  {
    
    public func dispatch(_ dispatchable: Dispatchable<RSAFCombinedState>) {
        
        switch dispatchable.object {
        case let action as Action:
            dispatch(action)
            dispatchable.callback?(self.state)
            
        
        case let actionCreator as ActionCreator:
            dispatch(actionCreator)
            dispatchable.callback?(self.state)
            
        case let asyncActionCreatorProvider as AsyncActionCreator:
            dispatch(asyncActionCreatorProvider, callback: dispatchable.callback)
 
        default:
            break
            
        }
    }
}



open class RSAFActionCreators: NSObject {
    
//    associatedtype RSAFStateType: StateType
    public typealias ActionCreator = (_ state: RSAFCombinedState, _ store: Store<RSAFCombinedState>) -> Action?
    public typealias AsyncActionCreator = (
        _ state: RSAFCombinedState,
        _ store: Store<RSAFCombinedState>,
        _ actionCreatorCallback: @escaping ((ActionCreator) -> Void)
        ) -> Void
    
    open static func setLoggedIn(loggedIn: Bool, callback:((RSAFCombinedState) -> Void)? = nil) -> Dispatchable<RSAFCombinedState> {
        
        let actionCreator:ActionCreator = { (state, store) in
            return SetLoggedInAction(loggedIn: loggedIn)
        }

        return Dispatchable(object: actionCreator, callback: callback)
    }
    
    open static func fetch() -> AsyncActionCreator {
        return { (state, store, actionCreatorCallback) in
            store.dispatch(Request())
            DispatchQueue.main.async {
                
                actionCreatorCallback({ (store, state) in
                    return Response()
                })
                
            }
        }
    }
    
    open static func queueActivity(uuid: UUID, activityRun: RSAFActivityRun, taskBuilder: RSTBTaskBuilder) -> Dispatchable<RSAFCombinedState> {
        return Dispatchable(object: QueueActivityAction(uuid: uuid, activityRun: activityRun, taskBuilder: taskBuilder))
    }
    
    open static func queueActivity(fromScheduleItem scheduleItem: RSAFScheduleItem, taskBuilder: RSTBTaskBuilder) -> Dispatchable<RSAFCombinedState> {
        let activityRun = RSAFActivityRun.create(from: scheduleItem)
        return queueActivity(uuid: UUID(), activityRun: activityRun, taskBuilder: taskBuilder)
    }
    
    open static func queueActivity(
        fromScheduleItem scheduleItem: RSAFScheduleItem,
        taskBuilderSelector: @escaping (RSAFCombinedState)->RSTBTaskBuilder?,
        callback:((RSAFCombinedState) -> Void)? = nil
        ) -> Dispatchable<RSAFCombinedState> {
        
        let actionCreator: ActionCreator = { (state, store) in
            
            if let taskBuilder = taskBuilderSelector(state) {
                let activityRun = RSAFActivityRun.create(from: scheduleItem)
                return QueueActivityAction(uuid: UUID(), activityRun: activityRun, taskBuilder: taskBuilder)
            }
            
            return nil
            
        }
        
        return Dispatchable(object: actionCreator, callback: callback)
    }
    
    open static func completeActivity(uuid: UUID, activityRun: RSAFActivityRun, taskResult: ORKTaskResult?, callback:((RSAFCombinedState) -> Void)? = nil) -> Dispatchable<RSAFCombinedState> {
        
        let asyncActionCreator: AsyncActionCreator = { (state, store, actionCreatorCallback) in
            
            if let onCompletionActionCreators = activityRun.onCompletionActionCreators {
                let dispatchables = onCompletionActionCreators.flatMap({ (creator) -> Dispatchable<RSAFCombinedState>? in
                    return creator(uuid, activityRun, taskResult)
                })
                dispatchables.forEach({ (dispatchable) in
                    store.dispatch(dispatchable)
                })
            }
            
            //this removes the actviity from the queue
            let completeAction = CompleteActivityAction(uuid: uuid, activityRun: activityRun, taskResult: taskResult)
            actionCreatorCallback( { (store, state) in
                return completeAction
            })
            
        }
        
        return Dispatchable(object: asyncActionCreator, callback: callback)
    }
    
    open static func processResults(uuid: UUID, activityRun: RSAFActivityRun, taskResult: ORKTaskResult, resultsProcessorSelector: @escaping (RSAFCombinedState)->RSRPResultsProcessor?, callback:((RSAFCombinedState) -> Void)? = nil) -> Dispatchable<RSAFCombinedState> {
        
        let actionCreator: ActionCreator = { (state, store) in
            
            if let resultsProcessor = resultsProcessorSelector(state),
                let resultTransforms = activityRun.resultTransforms {
                resultsProcessor.processResult(taskResult: taskResult, resultTransforms: resultTransforms)
            }
            
            return nil
            
        }
        
        return Dispatchable(object: actionCreator, callback: callback)
    }
    
    open static func setValueInExtensibleStorage(key: String, value: NSObject?) -> (RSAFCombinedState, Store<RSAFCombinedState>) -> Action? {
        
        return { (state, store) in
            return SetValueInExtensibleStorage(key: key, value: value)
        }
        
    }
    
    open static func clearStore() -> (RSAFCombinedState, Store<RSAFCombinedState>) -> Action? {
        return { (state, store) in
            return ClearStore()
        }
    }
    
    open static func createTaskBuilder(stateHelper: RSTBStateHelper?,
                                         elementGeneratorServices: [RSTBElementGenerator]?,
                                         stepGeneratorServices: [RSTBStepGenerator]?,
                                         answerFormatGeneratorServices: [RSTBAnswerFormatGenerator]?
        ) ->(RSAFCombinedState, Store<RSAFCombinedState>) -> Action? {
        return { (state, store) in
            let taskBuilder = RSTBTaskBuilder(
                stateHelper: stateHelper,
                elementGeneratorServices: elementGeneratorServices,
                stepGeneratorServices: stepGeneratorServices,
                answerFormatGeneratorServices: answerFormatGeneratorServices
            )
            return SetTaskBuilder(taskBuilder: taskBuilder)
        }
    }
    
    open static func createResultsProcessor(frontEndTransformers: [RSRPFrontEndTransformer.Type], backEnds: [RSRPBackEnd]) -> (RSAFCombinedState, Store<RSAFCombinedState>) -> Action? {
        return { (state, store) in
            let resultsProcessor = RSRPResultsProcessor(frontEndTransformers: frontEndTransformers, backEnds: backEnds)
            return SetResultsProcessor(resultsProcessor: resultsProcessor)
        }
    }
    
    open static func setTitleInfo(titleLabelText: String?, titleImage: UIImage?) -> Action {
        return SetTitle(titleLabelText: titleLabelText, titleImage: titleImage)
    }

}
