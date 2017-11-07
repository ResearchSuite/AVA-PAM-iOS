//
//  RSTBTaskGenerator.swift
//  Pods
//
//  Created by James Kizer on 6/30/17.
//
//

import Foundation
import ResearchKit
import Gloss

public protocol RSTBTaskGenerator {
    
    static func supportsType(type: String) -> Bool
    static func generateTask(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKTask?

}
