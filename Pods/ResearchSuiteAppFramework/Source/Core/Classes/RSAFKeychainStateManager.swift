//
//  RSAFKeychainStateManager.swift
//  Pods
//
//  Created by James Kizer on 3/25/17.
//
//

import UIKit
import ResearchKit

open class RSAFKeychainStateManager: RSAFStateManager {
    
    static fileprivate let keychainQueue = DispatchQueue(label: "keychainQueue")
    
    static func setKeychainObject(_ object: NSSecureCoding, forKey key: String) {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.setObject(object, forKey: key)
            }
        } catch let error {
            assertionFailure("Got error \(error) when setting \(key)")
        }
    }
    
    static func removeKeychainObject(forKey key: String) {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.removeObject(forKey: key)
            }
        } catch let error {
            assertionFailure("Got error \(error) when setting \(key)")
        }
    }
    
    static open func clearKeychain() {
        do {
            try keychainQueue.sync {
                try ORKKeychainWrapper.resetKeychain()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func getKeychainObject(_ key: String) -> NSSecureCoding? {
        
        return keychainQueue.sync {
            var error: NSError?
            let o = ORKKeychainWrapper.object(forKey: key, error: &error)
            if error == nil {
                return o
            }
            else {
                print("Got error \(error) when getting \(key). This may just be the key has not yet been set!!")
                return nil
            }
        }
        
    }
    
    static open func setValueInState(value: NSSecureCoding?, forKey: String) {
        if let val = value {
            RSAFKeychainStateManager.setKeychainObject(val, forKey: forKey)
        }
        else {
            RSAFKeychainStateManager.removeKeychainObject(forKey: forKey)
        }
    }
    
    static open func valueInState(forKey: String) -> NSSecureCoding? {
        return RSAFKeychainStateManager.getKeychainObject(forKey)
    }

}
