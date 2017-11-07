//
//  RSTBConsentSignatureGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/26/17.
//
//

import UIKit
import ResearchKit
import Gloss

public protocol RSTBConsentSignatureGenerator {
    static func supportsType(type: String) -> Bool
    static func generate(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKConsentSignature?
}
