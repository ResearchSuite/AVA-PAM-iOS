//
//  RSTBTextFieldStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import ResearchKit
import Gloss

open class RSTBTextFieldStepGenerator: RSTBQuestionStepGenerator {
    
    override open var supportedTypes: [String]! {
        return ["textfield"]
    }
    
    public override init(){}
    
    override open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let textFieldDescriptor = RSTBTextFieldStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let answerFormat: ORKTextAnswerFormat = {
            if let validationRegex = textFieldDescriptor.validationRegex {
                return ORKTextAnswerFormat(validationRegex: validationRegex, invalidMessage: textFieldDescriptor.invalidMessage ?? "Entry invalid")
            }
            else {
                return ORKTextAnswerFormat(maximumLength: textFieldDescriptor.maximumLength ?? 0)
            }
            
        } ()
        
        answerFormat.multipleLines = textFieldDescriptor.multipleLines
        
        switch textFieldDescriptor.textType {
    
        case .normal:
            break
        case .email:
            answerFormat.autocapitalizationType = .none
            answerFormat.autocorrectionType = .default
            answerFormat.spellCheckingType = .no
            answerFormat.keyboardType = .emailAddress
            answerFormat.isSecureTextEntry = false
        case .name:
            answerFormat.autocapitalizationType = .words
            answerFormat.autocorrectionType = .default
            answerFormat.spellCheckingType = .default
            answerFormat.keyboardType = .default
            answerFormat.isSecureTextEntry = false
        case .password:
            answerFormat.autocapitalizationType = .none
            answerFormat.autocorrectionType = .no
            answerFormat.spellCheckingType = .no
            answerFormat.keyboardType = .default
            answerFormat.isSecureTextEntry = true
        case .number:
            answerFormat.autocapitalizationType = .none
            answerFormat.autocorrectionType = .default
            answerFormat.spellCheckingType = .no
            answerFormat.keyboardType = .numberPad
            answerFormat.isSecureTextEntry = false
        }
        
        return answerFormat
    }
    
    override open func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        
        if let result = result as? ORKTextQuestionResult,
            let answer = result.textAnswer {
            return [
                "identifier": result.identifier,
                "type": type,
                "answer": answer
            ]
        }
        return  nil
    }
    
}
