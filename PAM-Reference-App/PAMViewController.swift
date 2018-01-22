//
//  ViewController.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework
import UserNotifications
import sdlrkx

class PAMViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var pamAssessmentItem: RSAFScheduleItem!
    var store: RSStore!
    @IBOutlet weak var settingsButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.store = RSStore()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let shouldDoSpot = self.delegate.store.get(key: "shouldDoSpot") as! Bool
      //  NSLog("%@should do spot at view: ", shouldDoSpot ?? "<nil>")
        
        if (shouldDoSpot) {
            NSLog("should do spot")
            self.launchPAMAssessment()
        }
        
    }
    
    func launchPAMAssessment() {
        self.pamAssessmentItem = AppDelegate.loadScheduleItem(filename:"pamSpot")
        self.launchActivity(forItem: (self.pamAssessmentItem)!)
        
    }
    
    func launchActivity(forItem item: RSAFScheduleItem) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
                
                if(item.identifier == "PAM"){
                    self?.store.set(value: false as NSSecureCoding, key: "shouldDoSpot")
                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "pamFileExists")
                }
            
            }
            
            
            self?.dismiss(animated: true, completion: nil)
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        
    }
    



}

