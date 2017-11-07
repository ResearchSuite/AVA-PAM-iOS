//
//  ConsentSample.swift
//  OMHClient
//
//  Created by James Kizer on 1/13/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import OMHClient

open class ConsentSample: OMHMediaDataPointBase {

    open var _fileName = "\(UUID().uuidString).pdf"
    open var fileName: String {
        return _fileName
    }
    
    static private let schema = OMHSchema(
        name: "example-consent",
        version: "1.1",
        namespace: "cornell")
    
    public init(consentURL: URL) {
        
        super.init()
        
        let uuid = UUID().uuidString
        
        let attachment = OMHMediaAttachment(fileName: self.fileName, fileURL: consentURL, mimeType: "application/pdf")
        self.addAttachment(attachment: attachment)
        
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    override open var schema: OMHSchema {
        return ConsentSample.schema
    }
    
    override open var body: [String: Any] {
        return ["consent": "consent"]
    }
}
