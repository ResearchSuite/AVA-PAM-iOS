//
//  SecurePersistentMap.swift
//  Pods
//
//  Created by James Kizer on 1/7/17.
//
//

import UIKit

open class SecurePersistentMap: NSObject {
    
    var cacheMap: [String: NSSecureCoding]!
    
    let mapDirectoryName: String
    let allowedClasses: [AnyClass]
    let lockQueue: DispatchQueue
    
    public init?(directoryName: String, allowedClasses: [AnyClass]) {
        
        self.mapDirectoryName = directoryName
        self.allowedClasses = allowedClasses
        
        self.lockQueue = DispatchQueue(label: "SPMLockQueue")
        
        super.init()
        
        //seee if we need to create the directory
        var isDirectory : ObjCBool = false
        
        self.lockQueue.sync {
            self.cacheMap = [:]
        }
        
        
        
        if FileManager.default.fileExists(atPath: self.mapDirectoryName, isDirectory: &isDirectory) {
            
            //if a file, remove file and add directory
            if isDirectory.boolValue {
                
                return
            }
            else {
                
                do {
                    try self.removeMapDirectory()
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
            
        }
        
        do {
            try self.createMapDirectory()
//            let attributes = try FileManager.default.attributesOfItem(atPath: self.mapDirectoryName)
//            debugPrint(attributes)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
    }
    
    private func createMapDirectory() throws {
        
        try FileManager.default.createDirectory(atPath: self.mapDirectoryName, withIntermediateDirectories: true, attributes: nil)
        var url: URL = URL(fileURLWithPath: self.mapDirectoryName)
        var resourceValues: URLResourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
        
    }
    
    private func removeMapDirectory() throws {
        
        try FileManager.default.removeItem(atPath: self.mapDirectoryName)
        
    }
    
    
    public func addValue(_ value: NSSecureCoding, forKey key: String) throws {
        
        if self.contains(key: key) {
            throw SecureQueueError.valueExists(key: key)
        }
        
        let filePath = self.mapDirectoryName.appending("/\(key)")
        let fileURL = URL(fileURLWithPath: filePath)

        let data: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        
        do {
            try data.write(to: fileURL, options: Data.WritingOptions.completeFileProtectionUnlessOpen)
            
            self.lockQueue.sync {
                self.cacheMap[key] = value
            }
            
        } catch let error as NSError {
            throw error
        }
        
    }
    
    public func getValueIfInMemory(forKey key: String) -> NSSecureCoding? {
        return self.lockQueue.sync {
            return self.cacheMap[key]
        }
    }
    
    
    public func getValue(forKey key: String) throws -> NSSecureCoding?  {
        
        guard let cachedValue = self.getValueIfInMemory(forKey: key) else {
            
            var valueFromDisk: NSSecureCoding
            
            let filePath = self.mapDirectoryName.appending("/\(key)")
            
            //                debugPrint(filePath)
            guard let data = FileManager.default.contents(atPath: filePath) else {
                return nil
            }
            
            let secureUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
            secureUnarchiver.requiresSecureCoding = true
            
            valueFromDisk = secureUnarchiver.decodeObject(of: self.allowedClasses, forKey: NSKeyedArchiveRootObjectKey) as! NSSecureCoding
            
            self.lockQueue.sync {
                self.cacheMap[key] = valueFromDisk
            }
            
            return valueFromDisk
        }
        
        
        return cachedValue
        
    }
    
    public func contains(key: String) -> Bool {

        if self.getValueIfInMemory(forKey: key) != nil {
            return true
        }
        else {
            let filePath = self.mapDirectoryName.appending("/\(key)")
//            debugPrint(filePath)
            
            let fileExists = FileManager.default.fileExists(atPath: filePath)
            return fileExists
        }
        
    }
    
    
    //note that we should probably be ok with the element being removed
    //more than once!
    public func removeValue(forKey key: String) throws {
        
        do {
            
            let filePath = self.mapDirectoryName.appending("/\(key)")
            try FileManager.default.removeItem(atPath: filePath)
            
            self.lockQueue.sync {
                self.cacheMap.removeValue(forKey: key)
                return
            }
            
        } catch let error as NSError {
            throw error
        }
        
    }
    
    public func removeAll() throws {
        
        //remove directory and recreate
        do {
            
            try self.removeMapDirectory()
            try self.createMapDirectory()
            
            self.lockQueue.sync {
                self.cacheMap = [:]
            }
            
        } catch let error as NSError {
            throw error
        }
    }
    
    public func destroy() throws {
        
        //remove directory and recreate
        do {
            
            try self.removeMapDirectory()
            
            self.lockQueue.sync {
                self.cacheMap = nil
            }
            
        } catch let error as NSError {
            throw error
        }
    }
    
    public func keys() throws -> [String] {
        
        return try FileManager.default.contentsOfDirectory(atPath: self.mapDirectoryName)
        
    }
    
    public func keysInMemory() -> [String] {
        
        let keys:[String] = self.lockQueue.sync {
            return Array(self.cacheMap.keys)
        }
        
        return keys
        
    }
    
    public func keyInMemory(key: String) -> Bool {
        return self.lockQueue.sync {
            return self.cacheMap[key] != nil
        }
    }
    
    
}
