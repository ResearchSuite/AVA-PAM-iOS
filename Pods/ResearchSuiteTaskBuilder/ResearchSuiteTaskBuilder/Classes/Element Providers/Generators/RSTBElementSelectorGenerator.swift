//
//  RTSBElementSelectorGenerator.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import Gloss

open class RSTBElementSelectorGenerator: RSTBBaseElementGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "elementSelector"
    ]
    
    open var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateElements(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> [JSON]? {
        
        guard let descriptor = RSTBElementSelectorDescriptor(json: jsonObject),
            descriptor.elementList.count > 0 else {
                return nil
        }
        
        let elements: [JSON] = descriptor.elementList
        switch (descriptor.selectorType) {
        case "random":
            return [elements.random()!]
        case "selectOneByDate":
            
            //note that this algo was checked via playground and seems to provide
            //"good enough" distribution
            //note that nested selectors should use different UUIDStorageKeys
            //same UUIDStorageKeys should provide the same hash value on same day
            //thus allowing us to vary based on date alone
            let userPortionString: String = {
                
                guard let uuidStorageKey: String = "UUIDStorageKey" <~~ jsonObject,
                    let stateHelper = helper.stateHelper else {
                        return ""
                }
                
                if let uuid = stateHelper.valueInState(forKey: uuidStorageKey) as? String {
                    return uuid
                }
                else {
                    let uuid: String = UUID().uuidString
                    stateHelper.setValueInState(value: uuid as NSSecureCoding!, forKey: uuidStorageKey)
                    return uuid
                }
                
            } ()
            
            let date: Date = {
                guard let dayOffset: Int = "dayOffset" <~~ jsonObject else {
                    return Date()
                }
                
                return Date(timeIntervalSinceNow: TimeInterval(dayOffset) + 24.0 * 60.6 * 60.0)
            } ()
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let datePortionString = dateFormatter.string(from: date)
            
            print(datePortionString)
            
            let hash: Int = userPortionString.hashValue ^ datePortionString.hashValue
            
            let index: Int = abs(hash) % elements.count
            if elements.indices.contains(index) {
                return [elements[index]]
            }
            else {
                return nil
            }
            
        default:
            return elements
            
        }
    }
    
}
