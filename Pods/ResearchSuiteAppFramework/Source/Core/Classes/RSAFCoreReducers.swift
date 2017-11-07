//
//  RSAFCoreReducers.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import UIKit
import ReSwift

//public protocol RSAFCoreReducer: AnyReducer {
//    func handleAction(action: Action, state: RSAFCoreState?) -> RSAFCoreState
//}
//
//extension RSAFCoreReducer {
//    
//    func _handleAction(action: Action, state: StateType?) -> StateType {
//        return self.handleAction(action: action, state: state as! RSAFCoreState)
//    }
//}

open class RSAFCoreReducer: RSAFBaseReducer {

//    public var secondaryReducer: (Action, RSAFCoreState?) -> RSAFCoreState {
//        return { action, coreState in
//            
//            return self.combinedReducer._handleAction(action: action, state: coreState) as! RSAFCoreState
//            
//        }
//    }
//    
//    public var combiner: (RSAFCombinedState, RSAFCoreState) -> RSAFCombinedState {
//        return { combinedState, coreState in
//            return RSAFCombinedState.newState(fromState: combinedState, coreState: coreState)
//        }
//    }
//    
//    public var selector: (RSAFCombinedState) -> (RSAFCoreState?) {
//        return { combinedState in
//            return combinedState.coreState as? RSAFCoreState
//        }
//    }
//
//    open var combinedReducer: AnyReducer {
//        return CombinedReducer(self.reducers)
//    }
    
    open static let reducer = CombinedReducer([
        AppStateReducer(),
        ActivityQueueReducer(),
//        ResultsQueueReducer(),
        ExtensibleStorageReducer(),
        RSReducer(),
        TitleReducer()
    ])
    
    open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
        return RSAFCoreReducer.reducer._handleAction(action: action, state: state) as! RSAFBaseState
    }
    
    final class AppStateReducer: RSAFBaseReducer {
        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
            
            switch action {
                
            case let loggedInAction as SetLoggedInAction:
                return RSAFCoreState.newState(fromState: state, loggedIn: loggedInAction.loggedIn)
                
            default:
                return state
            }
        }
    
    }
    
    final class ActivityQueueReducer: RSAFBaseReducer {

        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
            
            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
            
            switch action {
                
            case let queueActivityAction as QueueActivityAction:
                let newActivityQueue = state.activityQueue + [(queueActivityAction.uuid, queueActivityAction.activityRun, queueActivityAction.taskBuilder)]
                return RSAFCoreState.newState(fromState: state, activityQueue: newActivityQueue)
                
            case let completeActivityAction as CompleteActivityAction:
                let newActivityQueue = state.activityQueue.filter({ (uuid: UUID, _, _) -> Bool in
                    return uuid != completeActivityAction.uuid
                })
                return RSAFCoreState.newState(fromState: state, activityQueue: newActivityQueue)
                
            default:
                return state
            }
            
        }
        
    }
    
    final class TitleReducer: RSAFBaseReducer {
        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
            
            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
            
            switch action {
                
            case let setTitle as SetTitle:
                return RSAFCoreState.newState(
                    fromState: state,
                    titleLabelText: setTitle.titleLabelText,
                    titleImage: setTitle.titleImage
                )

            default:
                return state
            }
            
        }
    }
    
//    final class ResultsQueueReducer: RSAFBaseReducer {
//        
//        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
//            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
//            
//            switch action {
//                
//            case let completeActivityAction as CompleteActivityAction:
//                if let taskResult = completeActivityAction.taskResult {
//                    let newResultsQueue = state.resultsQueue + [(completeActivityAction.uuid, completeActivityAction.activityRun, taskResult)]
//                    return RSAFCoreState.newState(
//                        fromState: state,
//                        resultsQueue: newResultsQueue
//                    )
//                }
//                else {
//                    return state
//                }
//                
//            case let resultsProcessedAction as ResultsProcessedAction:
//                let newResultsQueue = state.resultsQueue.filter({ (uuid: UUID, _, _) -> Bool in
//                    return uuid != resultsProcessedAction.uuid
//                })
//                return RSAFCoreState.newState(
//                    fromState: state,
//                    resultsQueue: newResultsQueue
//                )
//                
//            default:
//                return state
//            }
//        }
//    }
    
    final class ExtensibleStorageReducer: RSAFBaseReducer {
        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
            
            switch action {
                
            case let setValueAction as SetValueInExtensibleStorage:
                
                var extensibleStorageDict: [String: NSObject] = state.extensibleStorage
                
                let key = setValueAction.key
                
                if let value = setValueAction.value {
                    extensibleStorageDict[key] = value
                }
                else {
                    extensibleStorageDict.removeValue(forKey: key)
                }
                
                return RSAFCoreState.newState(
                    fromState: state,
                    extensibleStorage: extensibleStorageDict
                )
                
            default:
                return state
            }
        }
    }
    
    final class RSReducer: RSAFBaseReducer {
        open override func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
            let state = (state ?? RSAFCoreState.empty()) as! RSAFCoreState
            
            switch action {
                
            case let setTaskBuilder as SetTaskBuilder:
                return RSAFCoreState.newState(
                    fromState: state,
                    taskBuilder: setTaskBuilder.taskBuilder
                )
                
            case let setResultsProcessor as SetResultsProcessor:
                return RSAFCoreState.newState(
                    fromState: state,
                    resultsProcessor: setResultsProcessor.resultsProcessor
                )
                
            default:
                return state
            }
        }
    }

}
