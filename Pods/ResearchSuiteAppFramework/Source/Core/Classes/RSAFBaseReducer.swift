//
//  RSAFBaseReducer.swift
//  Pods
//
//  Created by James Kizer on 3/24/17.
//
//

import UIKit
import ReSwift

open class RSAFBaseReducer: NSObject, Reducer {
    
    public typealias ReducerStateType = RSAFBaseState
    
    open func handleAction(action: Action, state: RSAFBaseState?) -> RSAFBaseState {
        let state: RSAFBaseState = state ?? RSAFBaseState.empty()
        return state
    }

}
