//
//  RSEnhancedInstructionStep.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedInstructionStep: ORKInstructionStep {
    
    open var attributedTitle: NSAttributedString?
    open var attributedText: NSAttributedString?
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEnhancedInstructionStepViewController.self
    }

}
