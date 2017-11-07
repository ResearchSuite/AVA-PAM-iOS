//
//  RSAFCombinedState.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ReSwift

open class RSAFCombinedState: NSObject, StateType {
    
    open let coreState: RSAFBaseState
    open let middlewareState: RSAFBaseState
    open let appState: RSAFBaseState
    
    init(
        coreState: RSAFBaseState,
        middlewareState: RSAFBaseState,
        appState: RSAFBaseState ) {
        
        self.coreState = coreState
        self.middlewareState = middlewareState
        self.appState = appState
        
    }
    
    static func newState(
        fromState: RSAFCombinedState,
        coreState: RSAFBaseState? = nil,
        middlewareState: RSAFBaseState? = nil,
        appState: RSAFBaseState? = nil
        ) -> RSAFCombinedState {
        
        return RSAFCombinedState (
            coreState: coreState ?? fromState.coreState,
            middlewareState: middlewareState ?? fromState.middlewareState,
            appState: appState ?? fromState.appState
        )
    }
    
    override open var description: String {
        
        return "\n\tcoreState: \(self.coreState)\n\tmiddlewareState: \(self.middlewareState)\n\tappState: \(self.appState)"
    
    }
    
}

//public class RSAFCombinedState<CoreStateType: StateType, MiddlewareStateType: StateType, AppStateType: StateType>: StateType {
//    
//    let coreState: CoreStateType
//    let middlewareState: MiddlewareStateType
//    let appState: AppStateType
//    
//    init(
//        coreState: CoreStateType,
//        middlewareState: MiddlewareStateType,
//        appState: AppStateType ) {
//        
//        self.coreState = coreState
//        self.middlewareState = middlewareState
//        self.appState = appState
//        
//    }
//    
//    static func newState(
//        fromState: RSAFCombinedState,
//        coreState: CoreStateType? = nil,
//        middlewareState: MiddlewareStateType? = nil,
//        appState: AppStateType? = nil
//        ) -> RSAFCombinedState {
//        
//        return RSAFCombinedState (
//            coreState: coreState ?? fromState.coreState,
//            middlewareState: middlewareState ?? fromState.middlewareState,
//            appState: appState ?? fromState.appState
//        )
//    }
//    
//}
