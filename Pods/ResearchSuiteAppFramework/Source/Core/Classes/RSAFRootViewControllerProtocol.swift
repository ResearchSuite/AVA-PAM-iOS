//
//  RSAFRootViewController.swift
//  Pods
//
//  Created by James Kizer on 3/22/17.
//
//

import UIKit
import ReSwift
import ResearchKit
import ResearchSuiteTaskBuilder


public protocol RSAFRootViewControllerProtocolDelegate: class {
    func activityRunDidComplete(activityRun: RSAFActivityRun)
}

public protocol RSAFRootViewControllerProtocol {
    
    var contentHidden: Bool { get set }
    var presentedActivity: UUID? { get set }
    
    var store: Store<RSAFCombinedState>? { get }
    var taskBuilder: RSTBTaskBuilder? { get set }
    weak var RSAFDelegate: RSAFRootViewControllerProtocolDelegate? { get set }
    func runActivity(uuid: UUID, activityRun: RSAFActivityRun, taskBuilder: RSTBTaskBuilder, completion: @escaping ()->Void)
    
}

extension RSAFRootViewControllerProtocol {
    
    public var store: Store<RSAFCombinedState>? {
        return nil
    }
    
//    public var taskBuilder: RSTBTaskBuilder? {
//        return nil
//    }
    
    public func runActivity(uuid: UUID, activityRun: RSAFActivityRun, taskBuilder: RSTBTaskBuilder, completion: @escaping ()->Void) {
        
        let store = self.store
        
        guard let vcSelf = self as? UIViewController,
            let steps = taskBuilder.steps(forElement: activityRun.activity),
            steps.count > 0 else {
            
                DispatchQueue.main.async {
                    store?.dispatch(RSAFActionCreators.completeActivity(uuid: uuid, activityRun: activityRun, taskResult: nil, callback: { (state) in
                        completion()
                    }))
                }
                
                return
        }
        
        let task = ORKOrderedTask(identifier: activityRun.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak vcSelf] (taskViewController, reason, error) in
            
            let taskResult: ORKTaskResult? = (reason == ORKTaskViewControllerFinishReason.completed) ?
                taskViewController.result : nil
            
            //why are we dispatching this action before we dismiss the VC?
            //I think it's because this could affect state of VCs behind this one, so we don't want the updates to look janky
            store?.dispatch(RSAFActionCreators.completeActivity(uuid: uuid, activityRun: activityRun, taskResult: taskResult, callback: { (state) in
                
                vcSelf?.dismiss(animated: true, completion: completion)
            }))
            
        }
        
        let taskViewController = RSAFTaskViewController(activityUUID: uuid, task: task, taskFinishedHandler: taskFinishedHandler)
        
        
        vcSelf.present(taskViewController, animated: true, completion: nil)
        
    }
}
