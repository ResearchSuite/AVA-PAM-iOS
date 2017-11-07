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

class PAMViewController: RKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let steps = self.delegate.taskBuilder.steps(forElementFilename: "pam") else { return }
        let task = ORKOrderedTask(identifier: "PAM identifier", steps: steps)
        self.launchAssessmentForTask(task)
        
    }


}

