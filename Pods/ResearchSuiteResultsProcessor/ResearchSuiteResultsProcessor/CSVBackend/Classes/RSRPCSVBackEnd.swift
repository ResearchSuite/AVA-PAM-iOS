//
//  RSRPCSVBackEnd.swift
//  Pods
//
//  Created by James Kizer on 4/29/17.
//
//

import UIKit

open class RSRPCSVBackEnd: RSRPBackEnd {
    
    
//    var datapoints : [RSRPCSVDatapoint] = []
    
    let outputDirectory: URL
    
    public init(outputDirectory: URL){
        print(outputDirectory)
        self.outputDirectory = outputDirectory
        
        //see if we need to create the directory
        var isDirectory : ObjCBool = false
        
        if FileManager.default.fileExists(atPath: outputDirectory.absoluteString, isDirectory: &isDirectory) {
            
            //if a file, remove file and add directory
            if isDirectory.boolValue {
                
                return
            }
            else {
                
                do {
                    try self.removeDirectory(directory: outputDirectory)
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
            
        }
        
        do {
            try self.createDirectory(directory: outputDirectory)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    private func createDirectory(directory: URL) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        var url: URL = directory
        var resourceValues: URLResourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
    }
    
    private func removeDirectory(directory: URL) throws {
        
        try FileManager.default.removeItem(at: directory)
        
    }
    
    private func removeItem(itemName: String) throws {
        
        do {
            
            let fileURL = self.outputDirectory.appendingPathComponent(itemName)
            print(fileURL)
            try FileManager.default.removeItem(at: fileURL)
            
        } catch let error as NSError {
            throw error
        }
    }
    
    public func removeAll() throws {
        
        //remove directory and recreate
        do {
            
            try self.removeDirectory(directory: self.outputDirectory)
            try self.createDirectory(directory: self.outputDirectory)

        } catch let error as NSError {
            throw error
        }
    }
    
    public func destroy() throws {
        
        //remove directory
        do {
            
            try self.removeDirectory(directory: self.outputDirectory)
            
        } catch let error as NSError {
            throw error
        }
    }
    
    private func addFile(itemName: String, text: String) throws {
        
        do {
            let fileURL = self.outputDirectory.appendingPathComponent(itemName)
            print(fileURL)
            
            guard let data: Data = text.data(using: .utf8) else {
                assertionFailure("failed to convert string to data")
                return
            }

            try data.write(to: fileURL, options: [Data.WritingOptions.completeFileProtectionUnlessOpen, Data.WritingOptions.atomicWrite] )
            
        } catch let error as NSError {
            throw error
        }
        
    }
    
    public func getFiles() -> [URL]? {
        do {
            return try FileManager.default.contentsOfDirectory(at: self.outputDirectory, includingPropertiesForKeys: nil)
        } catch let error as NSError {
            return nil
        }
    }
    
    public func add(intermediateResult: RSRPIntermediateResult) {
        
        if let builder = intermediateResult as? RSRPCSVDatapointBuilder {
            
            let datapoint: RSRPCSVDatapoint = builder.toDatapoint()
            do {
                try self.addFile(itemName: datapoint.identifier + ".csv", text: datapoint.toString())
            }
            catch let error as NSError {
                print(error)
            }
            
        }
        
    }

    
    //helper method to show email w/ files included
    //takes view controller
    
}
