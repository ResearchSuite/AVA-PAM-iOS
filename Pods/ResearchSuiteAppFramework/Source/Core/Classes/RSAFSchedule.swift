//
//  RSAFSchedule.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import Gloss

open class RSAFSchedule: Gloss.Decodable {
    open let type: String
    open let identifier: String
    open let title: String
    open let guid: String
    
    open let items: [RSAFScheduleItem]
    open let itemMap: [String:RSAFScheduleItem]
    
    // MARK: - Deserialization
    
    required public init?(json: JSON) {
        
        guard let type: String = "type" <~~ json,
            let identifier: String = "identifier" <~~ json,
            let title: String = "title" <~~ json,
            let guid: String = "guid" <~~ json,
            let items: [JSON] = "items" <~~ json else {
                return nil
        }
        self.type = type
        self.identifier = identifier
        self.title = title
        self.guid = guid
        
        self.items = items.flatMap { (json) -> RSAFScheduleItem? in
            
            return RSAFScheduleItem(json: json)
            
        }
        
        var itemMap: [String:RSAFScheduleItem] = [:]
        self.items.forEach { (item) in
            itemMap[item.identifier] = item
        }
        self.itemMap = itemMap
    }
}
