//
//  RSTBConsentSectionGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import ResearchKit
import Gloss

public protocol RSTBConsentSectionGenerator {
    static func supportsType(type: String) -> Bool
    static func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentSection?
}
