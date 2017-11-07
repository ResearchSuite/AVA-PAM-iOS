//
//  RSAFRootNavigationControllerViewController.swift
//  Pods
//
//  Created by James Kizer on 3/27/17.
//
//

import UIKit
import ReSwift
import ResearchSuiteTaskBuilder

open class RSAFRootNavigationControllerViewController: UINavigationController, RSAFRootViewControllerProtocol, StoreSubscriber {
    
    open weak var RSAFDelegate: RSAFRootViewControllerProtocolDelegate?

    open var taskBuilder: RSTBTaskBuilder?

    open var presentedActivity: UUID?
    fileprivate var state: RSAFCombinedState?
    
    open var contentHidden = false {
        didSet {
            guard contentHidden != oldValue && isViewLoaded else { return }
            
            if let vc = self.presentedViewController {
                vc.view.isHidden = contentHidden
            }
            
            self.view.isHidden = contentHidden
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.store?.subscribe(self)
    }
    
    deinit {
        self.store?.unsubscribe(self)
    }
    
    open func newState(state: RSAFCombinedState) {
        
        self.state = state
        if self.presentedActivity == nil,
            let coreState = state.coreState as? RSAFCoreState,
            let (uuid, activityRun, taskBuilder) = coreState.activityQueue.first {
            
            self.presentedActivity = uuid
            self.runActivity(uuid: uuid, activityRun: activityRun, taskBuilder: taskBuilder, completion: { [weak self] in
                self?.presentedActivity = nil
                
                //potentially launch new activity
                if let state = self?.state {
                    self?.newState(state: state)
                }
                
                self?.RSAFDelegate?.activityRunDidComplete(activityRun: activityRun)
            })
        }
        
    }
    
    open var store: Store<RSAFCombinedState>? {
        
        guard let delegate = UIApplication.shared.delegate as? RSAFApplicationDelegate else {
            return nil
        }
        
        return delegate.reduxStore
    }
    
//    open var taskBuilder: RSTBTaskBuilder? {
//        guard let delegate = UIApplication.shared.delegate as? RSAFApplicationDelegate else {
//            return nil
//        }
//        
//        return delegate.taskBuilderManager?.rstb
//    }


}
