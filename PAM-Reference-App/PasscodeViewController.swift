//
//  PasscodeViewController.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 1/26/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import ResearchSuiteAppFramework

class PasscodeViewController: UIViewController, ORKPasscodeDelegate {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red:0.38, green:0.22, blue:0.78, alpha:1.0)
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = color.cgColor
        startButton.layer.cornerRadius = 5
        startButton.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: Any) {
        
        if !UserDefaults.standard.bool(forKey: "PassCreated"){
            self.launchPasscode()
        }
    }
    
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        // stuff
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        // stuff
    }
    
    func launchPasscode (){
        let passcodeStep = ORKPasscodeStep(identifier:"passcode")
        passcodeStep.passcodeFlow = ORKPasscodeFlow(rawValue: 0)!
        passcodeStep.text="Please create a 4 digit pin"
        
        let authPassStep = ORKPasscodeStep(identifier:"passcode-auth")
        authPassStep.passcodeFlow = ORKPasscodeFlow(rawValue:1)!
        authPassStep.text="Please enter your 4 digit pin"
        
        let passcodeTask = ORKOrderedTask(identifier:passcodeStep.identifier,steps:[passcodeStep,authPassStep])
        // let taskViewController = ORKTaskViewController(task: passcodeTask, taskRun: nil)
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            
            
            if reason == ORKTaskViewControllerFinishReason.completed {
                //   let taskResult = taskViewController.result
                UserDefaults.standard.set(true, forKey: "PassCreated")
                
            }
            
            
            self?.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "PAMOnboarding", bundle: Bundle.main)
                let vc = storyboard.instantiateInitialViewController()
                let delegate = UIApplication.shared.delegate as! AppDelegate!
                delegate?.transition(toRootViewController: vc!, animated: true)
            })
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: passcodeTask,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
    }
    

    
    



}
