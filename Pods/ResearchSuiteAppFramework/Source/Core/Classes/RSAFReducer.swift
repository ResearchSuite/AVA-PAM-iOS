//
//  RSAFReducer.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import UIKit
import ReSwift

public protocol RSAFReducer: Reducer {
    
    func handleAction(action: Action, state: RSAFStateType?) -> RSAFStateType
    
}
