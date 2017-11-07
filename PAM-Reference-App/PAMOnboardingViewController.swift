//
//  PAMOnboardingViewController.swift
//  PAM-Reference-App
//
//  Created by Christina Tsangouri on 11/7/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework
import UserNotifications
import sdlrkx

class PAMOnboardingViewController: RKViewController {
    
  //  var store: RSStore!

    @IBOutlet weak var startButton: UIButton!
   // let delegate = UIApplication.shared.delegate as! AppDelegate
    var notifItem: RSAFScheduleItem!
    var pamAssessmentItem: RSAFScheduleItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     //   self.store = RSStore()
        let color = UIColor.init(colorLiteralRed: 0.42, green: 0.04, blue: 0.51, alpha: 1.0)
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = color.cgColor
        startButton.layer.cornerRadius = 5
        startButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startAction(_ sender: Any) {
        self.notifItem = AppDelegate.loadScheduleItem(filename: "notification")
        self.launchActivity(forItem: (self.notifItem)!)
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
                
                if(item.identifier == "notification_date"){
                    
                    let result = taskResult.stepResult(forStepIdentifier: "notification_time_picker")
                    let timeAnswer = result?.firstResult as? ORKTimeOfDayQuestionResult
                    
                    let resultAnswer = timeAnswer?.dateComponentsAnswer

                    self?.setNotification(resultAnswer: resultAnswer!)
                    
                }
                
            }
            
            self?.dismiss(animated: true, completion: {
                
                if(item.identifier == "notification_date"){
                    guard let steps = self?.delegate.taskBuilder.steps(forElementFilename: "pam") else { return }
                    let task = ORKOrderedTask(identifier: "PAM identifier", steps: steps)
                    self?.launchAssessmentForTask(task)
                    
                }
                
                
//                if(item.identifier == "PAMTask"){
//                    self?.store.setValueInState(value: false as NSSecureCoding, forKey: "shouldDoSpot")
//                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//                    let vc = storyboard.instantiateInitialViewController()
//                    appDelegate.transition(toRootViewController: vc!, animated: true)
//                }
                
            })
            
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        
    }
    
    func setNotification(resultAnswer: DateComponents) {
        
        var userCalendar = Calendar.current
        userCalendar.timeZone = TimeZone(abbreviation: "EDT")!
        
        var fireDate = NSDateComponents()
        
        let hour = resultAnswer.hour
        let minutes = resultAnswer.minute
        
        fireDate.hour = hour!
        fireDate.minute = minutes!
        
        self.delegate.store.setValueInState(value: String(describing:hour!) as NSSecureCoding, forKey: "notificationHour")
        self.delegate.store.setValueInState(value: String(describing:minutes!) as NSSecureCoding, forKey: "notificationMinutes")
        
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = "PAM"
            content.body = "It'm time to complete your PAM Spot Assessment"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate as DateComponents,
                                                        repeats: true)
            
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                }
            })
            
        } else {
            // Fallback on earlier versions
            
            let dateToday = Date()
            let day = userCalendar.component(.day, from: dateToday)
            let month = userCalendar.component(.month, from: dateToday)
            let year = userCalendar.component(.year, from: dateToday)
            
            fireDate.day = day
            fireDate.month = month
            fireDate.year = year
            
            let fireDateLocal = userCalendar.date(from:fireDate as DateComponents)
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = fireDateLocal
            localNotification.alertTitle = "PAM"
            localNotification.alertBody = "It's time to complete your PAM Spot Assessment"
            localNotification.timeZone = TimeZone(abbreviation: "EDT")!
            //set the notification
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        
        
    }



}
