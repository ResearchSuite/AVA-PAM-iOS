//
//  RSAFCombinedReducer.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import UIKit
import ReSwift

//public protocol RSAFSelectorReducer: SelectorReducerType {
//    typealias PrimaryReducerStateType = RSAFCombinedState
//}



open class RSAFCombinedReducer: Reducer {
    
    public typealias ReducerStateType = RSAFCombinedState
    
    let coreReducer: RSAFBaseReducer
    let middlewareReducer: RSAFBaseReducer
    let appReducer: RSAFBaseReducer
    
    public init(coreReducer: RSAFBaseReducer, middlewareReducer: RSAFBaseReducer, appReducer: RSAFBaseReducer) {
        self.coreReducer = coreReducer
        self.middlewareReducer = middlewareReducer
        self.appReducer = appReducer
    }
    
    open func handleAction(action: Action, state: RSAFCombinedState?) -> RSAFCombinedState {
        
        if let state = state {
            return RSAFCombinedState.newState(
                fromState: state,
                coreState: coreReducer.handleAction(action: action, state: state.coreState),
                middlewareState: middlewareReducer.handleAction(action: action, state: state.middlewareState),
                appState: appReducer.handleAction(action: action, state: state.appState)
            )
        }
        else {
            return RSAFCombinedState(
                coreState: coreReducer.handleAction(action: action, state: state?.coreState),
                middlewareState: middlewareReducer.handleAction(action: action, state: state?.middlewareState),
                appState: appReducer.handleAction(action: action, state: state?.appState)
            )
        }
        
    }
}
