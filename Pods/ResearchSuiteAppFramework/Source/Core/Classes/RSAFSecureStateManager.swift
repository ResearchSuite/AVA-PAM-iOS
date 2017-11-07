//
//  RSAFSecureStateManager.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit

public protocol RSAFStateManager {
    
    static func setValueInState(value: NSSecureCoding?, forKey: String)
    static func valueInState(forKey: String) -> NSSecureCoding?

}
