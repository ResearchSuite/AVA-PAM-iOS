//
//  RSEnhancedTextScaleStep.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedTextScaleStep: RSStep {
    
    let answerFormat: RSEnhancedTextScaleAnswerFormat
    open override func stepViewControllerClass() -> AnyClass {
        return RSEnhancedTextScaleStepViewController.self
    }
    
    public init(identifier: String, answerFormat: RSEnhancedTextScaleAnswerFormat) {
        self.answerFormat = answerFormat
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
