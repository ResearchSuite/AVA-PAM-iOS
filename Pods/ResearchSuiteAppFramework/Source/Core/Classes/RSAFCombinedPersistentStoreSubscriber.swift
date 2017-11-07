//
//  RSAFCombinedPersistentStoreSubscriber.swift
//  Pods
//
//  Created by James Kizer on 3/24/17.
//
//

import UIKit
import ReSwift

open class RSAFCombinedPersistentStoreSubscriber: NSObject, StoreSubscriber {
    

    let coreSubscriber: RSAFBasePersistentStoreSubscriber
    let middlewareSubscriber: RSAFBasePersistentStoreSubscriber
    let appSubscriber: RSAFBasePersistentStoreSubscriber
    
    public init(
        coreSubscriber: RSAFBasePersistentStoreSubscriber,
        middlewareSubscriber: RSAFBasePersistentStoreSubscriber,
        appSubscriber: RSAFBasePersistentStoreSubscriber) {
        self.coreSubscriber = coreSubscriber
        self.middlewareSubscriber = middlewareSubscriber
        self.appSubscriber = appSubscriber
    }
    
    open func loadState() -> RSAFCombinedState {
        return RSAFCombinedState(
            coreState: self.coreSubscriber.loadState(),
            middlewareState: self.middlewareSubscriber.loadState(),
            appState: self.appSubscriber.loadState())
    }
    
    open func newState(state: RSAFCombinedState) {
        
        coreSubscriber.newState(state: state.coreState)
        middlewareSubscriber.newState(state: state.middlewareState)
        appSubscriber.newState(state: state.appState)
        
        
    }
    
    
    
    
    
    
    
}
