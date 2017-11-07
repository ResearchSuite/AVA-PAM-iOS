//
//  RSEnhancedTextScaleStepViewController.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedTextScaleStepViewController: RSQuestionViewController {

    var value: Int?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let textScaleStep = self.step as? RSEnhancedTextScaleStep else {
            return
        }
        
        let answerFormat = textScaleStep.answerFormat
        
        guard let sliderView = RSSliderView.newView(minimumValue: 0, maximumValue: answerFormat.textChoices.count - 1) else {
                return
        }
        
        sliderView.minValueLabel.text = answerFormat.minValueLabel
        sliderView.maxValueLabel.text = answerFormat.maxValueLabel
        sliderView.minValueDescriptionLabel.text = answerFormat.minimumValueDescription
        sliderView.neutralValueDescriptionLabel.text = answerFormat.neutralValueDescription
        sliderView.maxValueDescriptionLabel.text = answerFormat.maximumValueDescription
        
        sliderView.onValueChanged = { value in
            self.value = value
            if value >= 0 && value < answerFormat.textChoices.count {
                sliderView.currentValueLabel.text = answerFormat.textChoices[value].text
                self.continueButtonEnabled = true
            }
            else {
                self.continueButtonEnabled = false
            }

            sliderView.setNeedsLayout()
            self.contentView.setNeedsLayout()
            
            
        }

        if let initializedResult = self.initializedResult as? ORKStepResult,
            let result = initializedResult.firstResult as? ORKChoiceQuestionResult,
            let choice = result.choiceAnswers?.first as? ORKTextChoice,
            let index = textScaleStep.answerFormat.textChoices.index(of: choice) {
            sliderView.setValue(value: index, animated: false)
        }
        else {
            sliderView.setValue(value: answerFormat.defaultIndex, animated: false)
        }
        
        sliderView.setNeedsLayout()
        
        
        self.contentView.addSubview(sliderView)
        self.contentView.setNeedsLayout()
    }
    
    override open func validate() -> Bool {
        guard let value = self.value,
            let textScaleStep = self.step as? RSEnhancedTextScaleStep,
            value >= 0 && value < textScaleStep.answerFormat.textChoices.count else {
                return false
        }
        return true
    }
    
    override open var result: ORKStepResult? {
        guard let parentResult = super.result else {
            return nil
        }
        
        if self.hasAppeared,
            let value = self.value,
            let step = self.step as? RSEnhancedTextScaleStep,
            value >= 0 && value < step.answerFormat.textChoices.count {
            
            let choiceResult = ORKChoiceQuestionResult(identifier: step.identifier)
            choiceResult.startDate = parentResult.startDate
            choiceResult.endDate = parentResult.endDate
            choiceResult.choiceAnswers = [step.answerFormat.textChoices[value]]
            
            parentResult.results = [choiceResult]
        }
        
        return parentResult
    }

}
