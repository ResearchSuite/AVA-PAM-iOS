//
//  RSAFStateProtocol.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ReSwift

public protocol RSAFStateType: StateType {
    
    static func empty() -> Self
    init()

}
