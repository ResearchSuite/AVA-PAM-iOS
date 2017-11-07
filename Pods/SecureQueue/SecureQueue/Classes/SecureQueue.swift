//
//  SecureQueue.swift
//  Pods
//
//  Created by James Kizer on 1/8/17.
//
//

import UIKit

public class SecureQueue: NSObject {
    
    var directoryPath: String!
    var secureMap: SecurePersistentMap!
    
    var elementIDList: [String]!
    
    //need to be careful to prevent deadlocks
    //for now, make sure that any nested dispatches
    //take on the following order
    let elementsLockQueue: DispatchQueue
    let queueFileLockQueue: DispatchQueue
    let secureMapLockQueue: DispatchQueue
    
    private func elementsInMemory() -> [String] {
        return self.secureMapLockQueue.sync {
            self.secureMap.keysInMemory()
        }
    }
    
    private var queuePath: String {
        return self.directoryPath.appending("/queue")
    }
    
    private func saveQueue(elementIDList: [String]) throws {
        let filePath = self.directoryPath.appending("/queue")
        let fileURL = URL(fileURLWithPath: filePath)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: elementIDList)
        
        try data.write(to: fileURL, options: Data.WritingOptions.completeFileProtectionUntilFirstUserAuthentication)
    }
    
    private func loadQueue() throws -> [String] {
        
        let filePath = self.directoryPath.appending("/queue")
        
        guard let data = FileManager.default.contents(atPath: filePath) else {
            return []
        }
        
        let secureUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
        secureUnarchiver.requiresSecureCoding = true
        
        return secureUnarchiver.decodeObject(of: [NSArray.self], forKey: NSKeyedArchiveRootObjectKey) as? [String] ?? []
        
    }
    
    private func syncQueueAndMap(elementIDList: [String], secureMap: SecurePersistentMap) -> ([String], SecurePersistentMap)? {
        
        //assume that elelmentIDList is the source of truth.
        //get keys from secureMap, remove all those that are not in elementIDList
        var queueElements: Set<String> = Set(elementIDList)
        var mapElements: Set<String>
        do {
            mapElements = try Set(secureMap.keys())
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        
        //verify that queueElements is in fact a subset of mapElements
        //our assumption is that everything is ordered properly such that
        //elements are remove from the queue prior to being
        assert(queueElements.isSubset(of: mapElements), "FAILURE: Queue is not subset of secure map")
        
        //drop excess queue elements since data is gone anyway
        //NOTE that this should never happen in real life!!
        if !queueElements.isSubset(of: mapElements) {
            //get set subtraction, log that these elements are being dropped
            let droppedElements = queueElements.subtracting(mapElements)
            droppedElements.forEach({ (elementID) in
                print("dropping element: \(elementID)")
            })
            
            queueElements = queueElements.intersection(mapElements)
        }
        
        //drop execess elements from the map
        //NOTE: This can happen! Due to the way the code is structured,
        //it is possible for a failure (power loss, etc) to occurr after
        //the state of the queue has been saved BUT before the state of the map
        //has been saved
        
        let droppedMapElements = mapElements.subtracting(queueElements)
        droppedMapElements.forEach({ (elementID) in
            
            do {
                try secureMap.removeValue(forKey: elementID)
            } catch let error as NSError {
                //note that this isnt necessarily the worst thing in the world,
                //we can probably still continue depending on the error
                print(error.localizedDescription)
                
            }
        })
        
        return (Array(queueElements), secureMap)
    }
    
    public init?(directoryName: String, allowedClasses: [AnyClass]) {
        
        self.secureMapLockQueue = DispatchQueue(label: "SecureMapLockQueue" )
        self.elementsLockQueue = DispatchQueue(label: "ElementsLockQueue" )
        self.queueFileLockQueue = DispatchQueue(label: "QueueFileLockQueue")
    
        super.init()
        
        guard let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            return
        }
        
        self.directoryPath = documentsPath.appending("/\(directoryName)")
        print(self.directoryPath)
        
        guard let secureMap = SecurePersistentMap(directoryName: self.directoryPath.appending("/data"), allowedClasses: allowedClasses) else {
            return nil
        }
        
        var elementIDList: [String]!
        
        do {
            elementIDList = try self.loadQueue()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard let (syncdElelemtIDList, syncdSecureMap) = self.syncQueueAndMap(elementIDList: elementIDList, secureMap: secureMap) else { return nil }
        
        self.elementIDList = syncdElelemtIDList
        self.secureMap = syncdSecureMap
        
    }
    
    public func addElement(element: NSSecureCoding) throws {
        let elementID = UUID().uuidString
        
        //probably want to catch this here and change error
        //to something more understandable
        try self.secureMapLockQueue.sync {
            try self.secureMap.addValue(element, forKey: elementID)
        }
        
        //if we successfully added to the map, add to the queue
        self.elementsLockQueue.sync {
            let elementIDList = self.elementIDList + [elementID]
            self.elementIDList = elementIDList
            
            //note that we should not necessarily block waiting for the queue to save
            //for now, trust that it will happen in the background,
            //if this assumption proves invalid, we can change this to a sync and unwind
            self.queueFileLockQueue.async {
                do {
                    try self.saveQueue(elementIDList: elementIDList)
                } catch let error as NSError {
                    
                    //what happens if we can't save the queue?
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    //may need to turn this into callback
    public func removeElement(elementId: String) throws {
        //for now, only support remvoing the first element
        self.elementsLockQueue.sync {
            
            assert(self.elementIDList.first != nil && self.elementIDList.first! == elementId, "Currently only support removing the front of the queue")
            
            let elementIDList = self.elementIDList.filter({ (eid) -> Bool in
                return eid != elementId
            })
            
            self.elementIDList = elementIDList
            
            //note that we should not necessarily block waiting for the queue to save
            //for now, trust that it will happen in the background,
            //if this assumption proves invalid, we can change this to a sync and unwind
            self.queueFileLockQueue.async {
                do {
                    
                    try self.saveQueue(elementIDList: elementIDList)
                    
                    try self.secureMapLockQueue.sync {
                        try self.secureMap.removeValue(forKey: elementId)
                    }
                    
                } catch let error as NSError {
                    
                    //what happens if we can't save the queue?
                    print(error.localizedDescription)
                }
                
                
            }
        }
        
        
    }
    
    //we need to come up with a better scheme of keeping track of in progress uploads
    //for now, assume single consumer
    public func getFirstElement() throws -> (String, NSSecureCoding)? {
        
        return try self.elementsLockQueue.sync {
            
            if let front: String = self.elementIDList.first {
                
                return try self.secureMapLockQueue.sync {
                    if let element: NSSecureCoding = try self.secureMap.getValue(forKey: front) {
                        return (front, element)
                    }
                    return nil
                }
            }
            else {
                return nil
            }
            
        }
        
    }
    
    //we need to come up with a better scheme of keeping track of in progress uploads
    //for now, assume single consumer
    public func getFirstInMemoryElement() -> (String, NSSecureCoding)? {
        
        return self.elementsLockQueue.sync {
            
            //get list of in memory elements
            return self.secureMapLockQueue.sync {
                
                let inMemoryElements = Set(self.secureMap.keysInMemory())

                guard let front: String = self.elementIDList.first(where: { (elementID) -> Bool in
                    return inMemoryElements.contains(elementID)
                }) else {
                    return nil
                }

                //since this is in memory, it shoulndt throw
                if let element: NSSecureCoding = self.secureMap.getValueIfInMemory(forKey: front) {
                    return (front, element)
                }
                
                return nil
            }

        }
        
    }
    
    public var isEmpty: Bool {
        return self.elementsLockQueue.sync {
            return self.elementIDList.isEmpty
        }
    }
    
    public func clear() throws {
        //need to better understand failure modes
        
        self.elementsLockQueue.sync {
            do {
                try self.secureMapLockQueue.sync {
                    try self.secureMap.removeAll()
                }
            } catch let error {
                debugPrint(error)
            }
        }
        
        self.elementIDList = []
        try self.saveQueue(elementIDList: [])
        
    }
    
    public var count: Int {
        return self.elementsLockQueue.sync {
            return self.elementIDList.count
        }
    }

}
