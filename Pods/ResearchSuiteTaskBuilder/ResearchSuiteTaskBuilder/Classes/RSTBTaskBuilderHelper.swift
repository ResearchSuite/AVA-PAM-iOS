//
//  RSTBTaskBuilderHelper.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBTaskBuilderHelper: NSObject {
    weak var _stateHelper: RSTBStateHelper?
    open var stateHelper: RSTBStateHelper? {
        return _stateHelper
    }
    
    weak var _builder: RSTBTaskBuilder?
    open var builder: RSTBTaskBuilder? {
        return self._builder
    }
    
    public init(builder: RSTBTaskBuilder, stateHelper: RSTBStateHelper?) {
        
        self._builder = builder
        self._stateHelper = stateHelper
        super.init()
        
    }
    
    open func getJson(forFilename filename: String, inBundle bundle: Bundle = Bundle.main) -> JsonElement? {
        
        guard let filePath = bundle.path(forResource: filename, ofType: "json")
            else {
                assertionFailure("unable to locate file \(filename)")
                return nil
        }
        
        guard let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else {
                assertionFailure("Unable to create NSData with content of file \(filePath)")
                return nil
        }
        
        let json = try! JSONSerialization.jsonObject(with: fileContent, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return json as JsonElement?
    }
    
    open func getCustomStepDescriptor(forJsonObject jsonObject: JsonObject) -> RSTBCustomStepDescriptor? {
        guard let customStepDescriptor = RSTBCustomStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        if customStepDescriptor.parameters == nil,
            let parameterFileName = customStepDescriptor.parameterFileName,
            let parametersFromFile = self.getJson(forFilename: parameterFileName) as? JsonObject {
            
            customStepDescriptor.parameters = parametersFromFile
        }
        
        return customStepDescriptor
    }
}
