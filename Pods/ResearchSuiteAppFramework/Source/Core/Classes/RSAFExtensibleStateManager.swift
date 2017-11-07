//
//  RSAFReduxStateManager.swift
//  Pods
//
//  Created by James Kizer on 3/25/17.
//
//

import UIKit
import ReSwift
import ResearchSuiteTaskBuilder

open class RSAFExtensibleStateManager: NSObject, RSTBStateHelper, StoreSubscriber {

    var valueSelector: ((String) -> NSSecureCoding?)?
    
    let store: Store<RSAFCombinedState>
    
    public init(store: Store<RSAFCombinedState>) {
        self.store = store
        super.init()
    }
    
    open func newState(state: RSAFCombinedState) {
        if let coreState = state.coreState as? RSAFCoreState {
            self.valueSelector = RSAFCoreSelectors.getValueInExtensibleStorage(coreState)
        }
    }
    
    open func setValueInState(value: NSSecureCoding?, forKey: String) {
        self.store.dispatch(RSAFActionCreators.setValueInExtensibleStorage(key: forKey, value: value != nil ? value! as? NSObject : nil))
    }
    
    open func valueInState(forKey: String) -> NSSecureCoding? {
        return self.valueSelector?(forKey)
    }
    
    deinit {
        debugPrint("\(self) deiniting")
    }
    

}
