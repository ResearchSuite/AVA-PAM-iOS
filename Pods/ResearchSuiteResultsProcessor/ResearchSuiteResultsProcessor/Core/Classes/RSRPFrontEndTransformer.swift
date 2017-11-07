//
//  RSRPFrontEndTransformer.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit
import ResearchKit

public protocol RSRPFrontEndTransformer {
    static func transform(
        taskIdentifier: String,
        taskRunUUID: UUID,
        parameters: [String: AnyObject]
    ) -> RSRPIntermediateResult?
    
    static func supportsType(type: String) -> Bool
}
