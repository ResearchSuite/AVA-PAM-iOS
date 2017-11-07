//
//  OMHMediaAttachment.swift
//  Pods
//
//  Created by James Kizer on 1/13/17.
//
//

import UIKit

open class OMHMediaAttachment: NSObject, NSSecureCoding {
    
    let fileName: String
    let fileURL: URL
    let mimeType: String
    
    public init(fileName: String, fileURL: URL, mimeType: String) {
        self.fileName = fileName
        self.fileURL = fileURL
        self.mimeType = mimeType
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let fileName = aDecoder.decodeObject(of: NSString.self, forKey: "fileName") as? String,
            let fileURL = aDecoder.decodeObject(of: NSURL.self, forKey: "fileURL") as URL?,
            let mimeType = aDecoder.decodeObject(of: NSString.self, forKey: "mimeType") as String? else {
                return nil
        }
        
        self.fileName = fileName
        self.fileURL = fileURL
        self.mimeType = mimeType
        
    }
    
    open func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.fileURL, forKey: "fileURL")
        aCoder.encode(self.mimeType, forKey: "mimeType")
        
    }
    
}


