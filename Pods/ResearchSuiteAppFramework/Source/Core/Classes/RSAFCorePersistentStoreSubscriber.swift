//
//  RSAFCorePersistentStoreSubscriber.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

final public class RSAFCorePersistentStoreSubscriber: RSAFBasePersistentStoreSubscriber {
    
    static let kLoggedIn: String = "LoggedIn"
    static let kExtensibleStorage: String = "ExtensibleStorage"
    let loggedIn: RSAFPersistedValue<Bool>
    let extensibleStorage: RSAFPersistedValueMap
    
    override public init(stateManager: RSAFStateManager.Type) {
        self.loggedIn = RSAFPersistedValue<Bool>(key: RSAFCorePersistentStoreSubscriber.kLoggedIn, stateManager: stateManager)
        self.extensibleStorage = RSAFPersistedValueMap(key: RSAFCorePersistentStoreSubscriber.kExtensibleStorage, stateManager: stateManager)
        super.init(stateManager: stateManager)
    }
    
    open override func loadState() -> RSAFCoreState {
        return RSAFCoreState(
            loggedIn: self.loggedIn.get() ?? false,
            extensibleStorage: self.extensibleStorage.get()
        )
    }
    
//    open func newState(state: RSAFCoreState) {
//        self.extensibleStorage.set(map: RSAFCoreSelectors.getExtensibleStorage(state))
//    }
    
    open override func newState(state: RSAFBaseState) {
        if let coreState = state as? RSAFCoreState {
            self.loggedIn.set(value: RSAFCoreSelectors.isLoggedIn(coreState))
            self.extensibleStorage.set(map: RSAFCoreSelectors.getExtensibleStorage(coreState))
        }
    }
    
//    
//    open override func newState(state: RSAFCoreState) {
//        self.extensibleStorage.set(map: self.selectors.getExtensibleStorage(state))
//    }
}
