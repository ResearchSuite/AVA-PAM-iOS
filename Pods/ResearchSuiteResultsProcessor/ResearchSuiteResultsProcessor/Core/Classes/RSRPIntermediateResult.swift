//
//  RSRPIntermediateResult.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit

open class RSRPIntermediateResult: NSObject {
    
    open let type: String
    open var uuid: UUID
    open var taskIdentifier: String
    open var taskRunUUID: UUID
    open var startDate: Date?
    open var endDate: Date?
    
    //note that userInfo MUST be JSON serializable
    open var userInfo: [String: Any]?
    
    public init(
        type: String,
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID
    ) {
        self.type = type
        self.uuid = uuid
        self.taskIdentifier = taskIdentifier
        self.taskRunUUID = taskRunUUID
        
        super.init()
    }
    
}
