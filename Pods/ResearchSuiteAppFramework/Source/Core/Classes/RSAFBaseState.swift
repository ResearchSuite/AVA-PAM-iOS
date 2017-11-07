//
//  RSAFEmptyState.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

open class RSAFBaseState: NSObject, RSAFStateType {
    
    public required override init() {
        
    }
    
    open class func empty() -> Self {
        return self.init()
    }
}
