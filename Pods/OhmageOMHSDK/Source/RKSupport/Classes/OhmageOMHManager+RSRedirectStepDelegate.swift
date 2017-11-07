//
//  OhmageOMHManager+RSRedirectStepDelegate.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit
import ResearchSuiteExtensions

extension OhmageOMHManager: RSRedirectStepDelegate {
    public func redirectViewControllerDidLoad(viewController: RSRedirectStepViewController) {
        
    }
    
    public func handleURL(app: UIApplication, url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return self.handleURL(url: url)
    }
    
    public func beginRedirect(completion: @escaping ((Error?) -> ())) {
        self.beginRedirectSignIn(completion: completion)
    }
}
