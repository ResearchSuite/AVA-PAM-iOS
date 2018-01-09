//
//  RSRPCSVBuilder.swift
//  Pods
//
//  Created by James Kizer on 4/29/17.
//
//

import UIKit

public protocol RSRPCSVDatapointBuilder: class {
    
    var identifier: String { get }
    var header: String { get }
    var records: [String] { get }
    
}

extension RSRPCSVDatapointBuilder {
    public func toDatapoint() -> RSRPCSVDatapoint {
        return RSRPCSVDatapoint(identifier: self.identifier, header: self.header, records: self.records)
    }
}

open class RSRPCSVDatapoint {
    
    let identifier: String
    let header: String
    let records: [String]
    
    public init(identifier: String, header: String, records: [String]) {
        self.identifier = identifier
        self.header = header
        self.records = records
    }
    
    open func toString() -> String {
        let lines:[String] = [header] + records
        return lines.joined(separator: "\n")
    }
}
