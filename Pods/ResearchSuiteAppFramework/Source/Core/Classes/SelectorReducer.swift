//
//  SelectorReducer.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import UIKit
import ReSwift

public protocol SelectorReducerType {
    associatedtype PrimaryReducerStateType
    associatedtype SecondaryReducerStateType
    
    typealias ReducerStateType = PrimaryReducerStateType
    typealias SecondaryReducer = (Action, SecondaryReducerStateType?) -> (SecondaryReducerStateType)
    typealias Selector = (PrimaryReducerStateType) -> (SecondaryReducerStateType?)
    typealias Combiner = (PrimaryReducerStateType, SecondaryReducerStateType) -> (PrimaryReducerStateType)
    
    func handleAction(action: Action, state: PrimaryReducerStateType) -> PrimaryReducerStateType
    var selector: Selector { get }
    var combiner: Combiner { get }
    var secondaryReducer: SecondaryReducer { get }
}

extension SelectorReducerType {
    public func handleAction(action: Action, state: PrimaryReducerStateType) -> PrimaryReducerStateType {
        let substate: SecondaryReducerStateType? = self.selector(state)
        let newSubstate: SecondaryReducerStateType = self.secondaryReducer(action, substate)
        return self.combiner(state, newSubstate)
    }
}



//public struct SelectorReducer<PrimaryStateType: StateType, SecondaryStateType: StateType>: SelectorReducerType {
//    
//    private let _secondaryReducer: (Action, SecondaryStateType?) -> SecondaryStateType
//    public var secondaryReducer: (Action, SecondaryStateType?) -> SecondaryStateType {
//        return _secondaryReducer
//    }
//    
//    private let _combiner: (PrimaryStateType?, SecondaryStateType) -> PrimaryStateType
//    public var combiner: (PrimaryStateType?, SecondaryStateType) -> PrimaryStateType {
//        return _combiner
//    }
//    
//    private let _selector: (PrimaryStateType?) -> (SecondaryStateType?)
//    public var selector: (PrimaryStateType?) -> (SecondaryStateType?) {
//        return _selector
//    }
//    
//    public typealias PrimaryReducerStateType = PrimaryStateType
//    public typealias SecondaryReducerStateType = SecondaryStateType
//    
//    init(
//        selector: @escaping (PrimaryStateType?) -> (SecondaryStateType?),
//        secondaryReducer: @escaping (Action, SecondaryStateType?) -> SecondaryStateType,
//        combiner: @escaping (PrimaryStateType?, SecondaryStateType) -> PrimaryStateType ) {
//        self._selector = selector
//        self._secondaryReducer = secondaryReducer
//        self._combiner = combiner
//    }
//
//}
