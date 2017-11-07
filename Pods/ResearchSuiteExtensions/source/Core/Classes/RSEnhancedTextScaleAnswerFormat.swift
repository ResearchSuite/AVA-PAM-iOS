//
//  RSEnhancedTextScaleAnswerFormat.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedTextScaleAnswerFormat: ORKTextScaleAnswerFormat {
    
    open let maxValueLabel: String?
    open let minValueLabel: String?
    open let maximumValueDescription: String?
    open let neutralValueDescription: String?
    open let minimumValueDescription: String?
    
    public init(
        textChoices: [ORKTextChoice],
        defaultIndex: Int,
        vertical: Bool,
        maxValueLabel: String?,
        minValueLabel: String?,
        maximumValueDescription: String?,
        neutralValueDescription: String?,
        minimumValueDescription: String?
        ) {
        self.maxValueLabel = maxValueLabel
        self.minValueLabel = minValueLabel
        self.maximumValueDescription = maximumValueDescription
        self.neutralValueDescription = neutralValueDescription
        self.minimumValueDescription = minimumValueDescription
        
        super.init(textChoices: textChoices, defaultIndex: defaultIndex, vertical: vertical)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
