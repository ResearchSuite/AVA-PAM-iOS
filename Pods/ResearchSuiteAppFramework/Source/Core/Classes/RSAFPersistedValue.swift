//
//  RSAFPersistedValue.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

class RSAFPersistedValue<T: Equatable>: RSAFObservableValue<T> {
    
    let key: String
    let stateManager: RSAFStateManager.Type
    
    init(key: String, stateManager: RSAFStateManager.Type) {
        self.key = key
        self.stateManager = stateManager
        
        let observationClosure: ObservationClosure = { value in
            let secureCodingValue = value as? NSSecureCoding
            stateManager.setValueInState(value: secureCodingValue, forKey: key)
        }
        
        super.init(
            initialValue: stateManager.valueInState(forKey: key) as? T,
            observationClosure: observationClosure
        )
        
    }
    
    func delete() {
        stateManager.setValueInState(value: nil, forKey: self.key)
    }

}
