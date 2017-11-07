//
//  CTFLoginViewControllerStep.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit
import ResearchKit

open class CTFLoginStep: ORKFormStep {
    
    public static let CTFLoginStepIdentity = "CTFLoginStepIdentity"
    public static let CTFLoginStepPassword = "CTFLoginStepPassword"
    
    static public func usernameAnswerFormat() -> ORKTextAnswerFormat {
        let answerFormat = ORKTextAnswerFormat()
        answerFormat.keyboardType = UIKeyboardType.emailAddress
        answerFormat.multipleLines = false
        answerFormat.spellCheckingType = UITextSpellCheckingType.no
        answerFormat.autocapitalizationType = UITextAutocapitalizationType.none;
        answerFormat.autocorrectionType = UITextAutocorrectionType.no;
        
        return answerFormat
    }
    
    static public func passwordAnswerFormat() -> ORKTextAnswerFormat {
        let answerFormat = ORKTextAnswerFormat()
        
        answerFormat.keyboardType = UIKeyboardType.default
        answerFormat.isSecureTextEntry = true
        answerFormat.multipleLines = false
        answerFormat.spellCheckingType = UITextSpellCheckingType.no
        answerFormat.autocapitalizationType = UITextAutocapitalizationType.none;
        answerFormat.autocorrectionType = UITextAutocorrectionType.no;
        
        return answerFormat
    }
    
    
    open override func stepViewControllerClass() -> AnyClass {
        return self.loginViewControllerClass
    }
    
    open var loginViewControllerClass: AnyClass!
    
    open var loginViewControllerDidLoad: ((UIViewController) -> ())?
    
    var loginButtonTitle: String!
    var forgotPasswordButtonTitle: String?
    
    public init(identifier: String,
         title: String?,
         text: String?,
         identityFieldName: String = "Username",
         identityFieldAnswerFormat: ORKAnswerFormat = CTFLoginStep.usernameAnswerFormat(),
         passwordFieldName: String = "Password",
         passwordFieldAnswerFormat: ORKAnswerFormat = CTFLoginStep.passwordAnswerFormat(),
         loginViewControllerClass: AnyClass = CTFLoginStepViewController.self,
         loginViewControllerDidLoad: ((UIViewController) -> ())? = nil,
         loginButtonTitle: String = "Login",
         forgotPasswordButtonTitle: String?) {
        
        super.init(identifier: identifier, title: title, text: text)
        
        let identityItem = ORKFormItem(identifier: CTFLoginStep.CTFLoginStepIdentity,
                                       text: identityFieldName,
                                       answerFormat: identityFieldAnswerFormat,
                                       optional: false)
        
        let passwordItem = ORKFormItem(identifier: CTFLoginStep.CTFLoginStepPassword,
                                       text: passwordFieldName,
                                       answerFormat: passwordFieldAnswerFormat,
                                       optional: false)
        
        self.formItems = [identityItem, passwordItem]
        
        
        self.loginButtonTitle = loginButtonTitle
        
        self.forgotPasswordButtonTitle = forgotPasswordButtonTitle
        
        self.loginViewControllerClass = loginViewControllerClass
        self.loginViewControllerDidLoad = loginViewControllerDidLoad
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
