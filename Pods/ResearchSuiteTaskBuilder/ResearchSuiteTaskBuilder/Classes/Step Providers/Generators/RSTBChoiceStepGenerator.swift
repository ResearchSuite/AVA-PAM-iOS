//
//  RSTBChoiceStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBChoiceStepGenerator: RSTBQuestionStepGenerator {
    
    open var allowsMultiple: Bool {
        fatalError("abstract class not implemented")
    }
    
    public typealias ChoiceItemFilter = ( (RSTBChoiceItemDescriptor) -> (Bool))
    
    open func generateFilter(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ChoiceItemFilter? {
        
        return { choiceItem in
            return true
        }
    }
    
    open func generateChoices(items: [RSTBChoiceItemDescriptor], valueSuffix: String?, shouldShuffle: Bool?) -> [ORKTextChoice] {
        
        let shuffledItems = items.shuffled(shouldShuffle: shouldShuffle ?? false)
        
        return shuffledItems.map { item in
            
            let value: NSCoding & NSCopying & NSObjectProtocol = ({
                if let suffix = valueSuffix,
                    let stringValue = item.value as? String {
                    return (stringValue + suffix) as NSCoding & NSCopying & NSObjectProtocol
                }
                else {
                    return item.value
                }
            }) ()
            
            return ORKTextChoice(
                text: item.text,
                detailText: item.detailText,
                value: value,
                exclusive: item.exclusive)
        }
    }
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        guard let choiceStepDescriptor = RSTBChoiceStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let filteredItems: [RSTBChoiceItemDescriptor] = {
            
            if let itemFilter = self.generateFilter(type: type, jsonObject: jsonObject, helper: helper) {
                return choiceStepDescriptor.items.filter(itemFilter)
            }
            else {
                return choiceStepDescriptor.items
            }
            
        }()
        
        let choices = self.generateChoices(items: filteredItems, valueSuffix: choiceStepDescriptor.valueSuffix, shouldShuffle: choiceStepDescriptor.shuffleItems)
        
        guard choices.count > 0 else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(
            with: self.allowsMultiple ? ORKChoiceAnswerStyle.multipleChoice : ORKChoiceAnswerStyle.singleChoice,
            textChoices: choices
        )
        
        return answerFormat
    }
    
    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        
        if let result = result as? ORKChoiceQuestionResult,
            let choices = result.choiceAnswers as? [NSCoding & NSCopying & NSObjectProtocol] {
            return [
                "identifier": result.identifier,
                "type": type,
                "answer": choices
            ]
        }
        return  nil
    }

}

open class RSTBSingleChoiceStepGenerator: RSTBChoiceStepGenerator {
    
    public override init(){}
    
    override open var supportedTypes: [String]! {
        return ["singleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return false
    }
    
}

open class RSTBMultipleChoiceStepGenerator: RSTBChoiceStepGenerator {
    
    public override init(){}
    
    override open var supportedTypes: [String]! {
        return ["multipleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return true
    }
}
