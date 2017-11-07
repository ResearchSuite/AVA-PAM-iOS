//
//  RSAFBasePersistentStoreSubscriber.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

open class RSAFBasePersistentStoreSubscriber: RSAFPersistentStorageSubscriber {
    
    public typealias StoreSubscriberStateType = RSAFBaseState
    
    open let stateManager: RSAFStateManager.Type
    
    public init(stateManager: RSAFStateManager.Type) {
        self.stateManager = stateManager
    }
    
    open func loadState() -> RSAFBaseState {
        return RSAFBaseState()
    }

    open func newState(state: RSAFBaseState) {
        
    }
}
