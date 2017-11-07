//
//  RSAFPersistedValueMap.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

open class RSAFPersistedValueMap: NSObject {
    
    let stateManager: RSAFStateManager.Type
    
    let keyArrayKey: String
    let valueKeyComputeFunction: (String) -> (String)
    var map: [String: RSAFPersistedValue<NSObject>]
    var keys: RSAFPersistedValue<NSArray>
    
    init(key: String, stateManager: RSAFStateManager.Type) {
        self.stateManager = stateManager
        
        self.keyArrayKey = [key, "arrayKey"].joined(separator: ".")
        
        self.valueKeyComputeFunction = { valueKey in
            return [key, valueKey].joined(separator: ".")
        }
        self.keys = RSAFPersistedValue<NSArray>(key: self.keyArrayKey, stateManager: stateManager)
        
        if self.keys.get() == nil {
            self.keys.set(value: [String]() as NSArray)
        }
        
        self.map = [:]
        
        super.init()
        
        if let keys = self.keys.get() as? [String] {
            keys.forEach({ (key) in
                let valueKey = self.valueKeyComputeFunction(key)
                self.map[key] = RSAFPersistedValue<NSObject>(key: valueKey, stateManager: stateManager)
            })
        }
        
    }
    
    
    
    fileprivate subscript(key: String) -> NSObject? {
        
        get {
            
            if let persistedValue = self.map[key] {
                return persistedValue.get()
            }
            else {
                return nil
            }
        }
        
        set(newValue) {
            
            //check to see if key exists
            if let persistedValue = self.map[key] {
                
                assert(self.keys.get()!.contains(key), "PersistedValueMapError: Keys and Map Inconsistent")
                
                persistedValue.set(value: newValue)
                
                if newValue == nil {
                    persistedValue.delete()
                    self.map.removeValue(forKey: key)
                    let newKeys = (self.keys.get() as! [String]).filter({ (k) -> Bool in
                        return k != key
                    })
                    
                    self.keys.set(value: newKeys as NSArray)
                }
                
            }
            else {
                //key does not exist,
                
                if newValue != nil {
                    //add value to map
                    let newValueKey = self.valueKeyComputeFunction(key)
                    let newPersistedValue = RSAFPersistedValue<NSObject>(key: newValueKey, stateManager: stateManager)
                    newPersistedValue.set(value: newValue)
                    self.map[key] = newPersistedValue
                    let newKeys = (self.keys.get() as! [String]) + [key]
                    self.keys.set(value: newKeys as NSArray)
                }
            }
            
        }
    }
    
    func get() -> [String: NSObject] {
        
        
        let keys = self.keys.get() as! [String]
        var dict = [String: NSObject]()
        keys.forEach({ (key) in
            dict[key] = self.map[key]?.get()
        })
        
        return dict
    }
    
    func set(map: [String: NSObject]) {
        
        map.keys.forEach { (key) in
            self[key] = map[key]
        }
        
        //do set subtraction to potentially remove values
        let extraKeys: Set<String> = Set(self.map.keys).subtracting(Set(map.keys))
        extraKeys.forEach { (key) in
            self[key] = nil
        }
        
    }
    
    func clear() {
        self.set(map: [:])
    }
}
