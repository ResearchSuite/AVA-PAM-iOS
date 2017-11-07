//
//  RSEnhancedBaseStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache

public extension RSTBBaseStepGenerator {
    
    public func registerFormatters(template: Template) {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        
        template.register(percentFormatter,  forKey: "percent")
    }
    
    public func generateAttributedString(descriptor: RSTemplatedTextDescriptor, stateHelper: RSTBStateHelper, defaultAttributes: [String : Any]? = nil) -> NSAttributedString? {
        
        var arguments: [String: Any] = [:]
        
        descriptor.arguments.forEach { argumentKey in
            if let value: Any = stateHelper.valueInState(forKey: argumentKey) {
                arguments[argumentKey] = value
            }
        }
        
        var renderedString: String?
        //check for mismatch in argument length
        guard descriptor.arguments.count == arguments.count else {
            return nil
        }
        
        //then pass through handlebars
        do {
            let template = try Template(string: descriptor.template)
            self.registerFormatters(template: template)
            renderedString = try template.render(arguments)
        }
        catch let error {
            debugPrint(error)
            return nil
        }
        
        guard let markdownString = renderedString else {
            return nil
        }
        
        //finally through markdown -> NSAttributedString
        let md = SwiftyMarkdown(string: markdownString)
        md.h1.fontName = UIFont.preferredFont(forTextStyle: .title1).fontName
        let attributedString = md.attributedString()
        
        debugPrint(attributedString)
        return attributedString
    }

}
