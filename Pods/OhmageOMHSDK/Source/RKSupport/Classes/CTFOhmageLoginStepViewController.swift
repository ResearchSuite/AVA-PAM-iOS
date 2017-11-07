//
//  CTFOhmageLoginStepViewController.swift
//  Pods
//
//  Created by James Kizer on 1/24/17.
//
//

import UIKit
import ResearchKit

open class CTFOhmageLoginStepViewController: CTFLoginStepViewController {
    
    open var ohmageManager: OhmageOMHManager?
    
    open override func loginButtonAction(username: String, password: String, completion: @escaping ActionCompletion) {
        
        if let ohmageManager = self.ohmageManager {
            
            ohmageManager.signIn(username: username, password: password) { (error) in
                
                debugPrint(error)
                if error == nil {
                    self.loggedIn = true
                    completion(true)
                }
                else {
                    self.loggedIn = false
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Log in failed", message: "Username / Password are not valid", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                            print("OK")
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        completion(false)
                    }
                    
                }
                
            }
        }
        
        
    }
    
    open override func forgotPasswordButtonAction(completion: @escaping ActionCompletion) {
        
        self.loggedIn = false
        completion(true)
        
    }

}
