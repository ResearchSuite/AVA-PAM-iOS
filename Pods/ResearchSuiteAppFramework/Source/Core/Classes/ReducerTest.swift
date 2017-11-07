//
//  ReducerTest.swift
//  Pods
//
//  Created by James Kizer on 3/23/17.
//
//

import Foundation
import ReSwift


//public protocol CombinedStateAndReducer: Reducer {
//    var state: Self.ReducerStateType? { get }
//    func handleAction(action: Action, state: Self.ReducerStateType?) -> Self.ReducerStateType
//    func handleAction(action: Action, combinedStateAndReducer: Self) -> Self
//    func SRM<S: CombinedStateAndReducer>(_ action: Action, _ reducer: Self, _ selector: (Self)->(S), _ combiner: (S, Self)->(Self)) -> Self
//    init(state: Self.ReducerStateType?)
//    init()
//}
//
//extension CombinedStateAndReducer {
//    func SRM<S: CombinedStateAndReducer>(_ action: Action, _ reducer: Self, _ selector: (Self)->(S), _ combiner: (S, Self)->(Self)) -> Self {
//        //select
//        let subreducer: S = selector(reducer)
//        
//        //reduce
//        let newReducer: S = subreducer.handleAction(action: action, combinedStateAndReducer: subreducer)
//        
//        //merge
//        return combiner(newReducer, reducer)
//        
//    }
//}
//
//
//struct TestState1: StateType {
//    let testString: String
//}
//
//struct TestState2: StateType {
//    let testInt: Int
//}
//
//struct TestReducer1: Reducer {
//    func handleAction(action: Action, state: TestState1?) -> TestState1 {
//        let state = state ?? TestState1(testString: "")
//        
//        return state
//    }
//}
//
//struct TestReducer2: Reducer {
//    func handleAction(action: Action, state: TestState2?) -> TestState2 {
//        let state = state ?? TestState2(testInt: 0)
//        
//        return state
//    }
//}
//
//
//let combinedReducer = CombinedReducer([TestReducer1(), TestReducer2()])
//
//struct TestStateAndReducer1: CombinedStateAndReducer {
//    public init(state: TestState1?) {
//        self._state = state
//    }
//
//
//    internal var state: TestState1? {
//        return _state
//    }
//
//    let _state: TestState1?
//    
//    init() {
//        self._state = nil
//    }
//    
//    init(state: TestState1) {
//        self._state = state
//    }
//    
//    func handleAction(action: Action, state: TestState1?) -> TestState1 {
//        let state = state ?? TestState1(testString: "")
//        
//        return state
//    }
//    
//    func handleAction(action: Action, combinedStateAndReducer: TestStateAndReducer1) -> TestStateAndReducer1 {
//        let state = self.handleAction(action: action, state: self.state)
//        return TestStateAndReducer1(state: state)
//        
//    }
//
//}
//
////struct TestStateAndReducer2: CombinedStateAndReducer {
////    let testInt: Int
////    
////    func handleAction(action: Action, state: TestStateAndReducer2?) -> TestStateAndReducer2 {
////        let state = state ?? TestStateAndReducer2(testInt: 1)
////        
////        return state
////    }
////    
////    static func handleAction(action: Action, state: TestStateAndReducer2?) -> TestStateAndReducer2 {
////        let state = state ?? TestStateAndReducer2(testInt: 1)
////        
////        return state
////    }
////}
//
//struct CSTest: StateType {
//    let sar1: TestStateAndReducer1
//}
//
//struct CSRTest: CombinedStateAndReducer {
//    
//    
//    public func handleAction(action: Action, combinedStateAndReducer: CSRTest) -> CSRTest {
//        let state: CSTest = self.handleAction(action: action, state: self.state)
//        return CSRTest(state: state)
//    }
//
//    public init(state: CSTest?) {
//        self._state = state
//    }
// 
//    
//    
//    internal var state: CSTest? {
//        return _state
//    }
//    
//    let _state: CSTest?
//    
//    init() {
//        self._state = nil
//    }
//    
//    init(state: CSTest) {
//        self._state = state
//    }
//    
//    let sar1: TestStateAndReducer1
//    
//    
////    func SRM<S: CombinedStateAndReducer>(_ action: Action, _ reducer: CSRTest, _ selector: (CSRTest)->(S), _ combiner: (S, CSRTest)->(CSRTest)) -> CSRTest {
////        //select
////        let subreducer: S = selector(reducer)
////        
////        //reduce
////        let newReducer: S = subreducer.handleAction(action: action, combinedStateAndReducer: subreducer)
////        
////        //merge
////        return combiner(newReducer, reducer)
////        
////    }
//    
//    func handleAction(action: Action, state: CSTest?) -> CSTest {
////        let state = state ?? CSTest(sar1)
//        
//        var reducer = CSRTest(state: state)
//        
//        let sar1Selector: (CSRTest) -> (TestStateAndReducer1) = { reducer in
//            return reducer.sar1
//        }
//        
//        let sar1Combiner: (TestStateAndReducer1, CSRTest) -> (CSRTest) = { subreducer, reducer in
//            
//            let state = CSTest(sar1: subreducer)
//            return CSRTest(state: state)
//            
//        }
//        
//        reducer = reducer.SRM(action, reducer, sar1Selector, sar1Combiner)
//        
//        return state!
//    }
//    
//    
//}






