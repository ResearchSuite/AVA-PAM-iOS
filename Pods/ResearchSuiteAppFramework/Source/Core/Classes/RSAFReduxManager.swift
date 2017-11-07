//
//  RSAFReduxManager.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import UIKit
import ReSwift
import ResearchKit

open class RSAFReduxManager: NSObject {
    
    let store: Store<RSAFCombinedState>
    
    public init(initialState: RSAFCombinedState?, reducer: RSAFCombinedReducer) {
        
        let loggingMiddleware: Middleware = { dispatch, getState in
            return { next in
                return { action in
                    // perform middleware logic
                    let oldState: RSAFCombinedState? = getState() as? RSAFCombinedState
                    let retVal = next(action)
                    let newState: RSAFCombinedState? = getState() as? RSAFCombinedState
                    
                    print("\n")
                    print("*******************************************************")
                    if let oldState = oldState {
                        print("oldState: \(oldState)")
                    }
                    print("action: \(action)")
                    if let newState = newState {
                        print("newState: \(newState)")
                    }
                    print("*******************************************************\n")
                    
                    // call next middleware
                    return retVal
                }
            }
        }

        self.store = Store<RSAFCombinedState>(
            reducer: reducer,
            state: initialState,
            middleware: [loggingMiddleware]
        )
        
        super.init()
        
    }
    
    deinit {
        debugPrint("\(self) deiniting")
    }
}

