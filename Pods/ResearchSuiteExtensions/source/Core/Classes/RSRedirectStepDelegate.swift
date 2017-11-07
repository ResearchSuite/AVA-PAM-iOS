//
//  RSRedirectStepDelegate.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit

public protocol RSRedirectStepDelegate: RSOpenURLDelegate {
    
    func redirectViewControllerDidLoad(viewController: RSRedirectStepViewController)
    
    //this is used by the delegate to open the redirect URL
    //note that the delegate should store the completion handler
    func beginRedirect(completion: @escaping ((Error?) -> ()))

}
