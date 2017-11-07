//
//  RSRedirectStepViewController.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit
import ResearchKit

open class RSRedirectStepViewController: RSQuestionViewController {
    
    open var redirectDelegate: RSRedirectStepDelegate?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let step = self.step as? RSRedirectStep {
            self.setContinueButtonTitle(title: step.buttonText)
            self.redirectDelegate = step.delegate
        }
        
        self.redirectDelegate?.redirectViewControllerDidLoad(viewController: self)
        
    }

    override open func continueTapped(_ sender: Any) {
        
        self.redirectDelegate?.beginRedirect(completion: { (error) in
            debugPrint(error)
            if error == nil {
                DispatchQueue.main.async {
                    self.notifyDelegateAndMoveForward()
                }
            }
            else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Log in failed", message: "Username / Password are not valid", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        })
        
    }

}
