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

class PAMOnboardingViewController: UIViewController {
    
    var store: RSStore!

    let delegate = UIApplication.shared.delegate as! AppDelegate
    var notifItem: RSAFScheduleItem!
    var pamAssessmentItem: RSAFScheduleItem!
    var medlAssessmentItem: RSAFScheduleItem!
    let kActivityIdentifiers = "activity_identifiers"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.store = RSStore()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        let shouldSetNotif = self.store.valueInState(forKey: "shouldDoNotif") as! Bool
        
        if(shouldSetNotif){
            self.notifItem = AppDelegate.loadScheduleItem(filename: "notification")
            self.launchActivity(forItem: (self.notifItem)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    
                    self?.store.set(value: false as NSSecureCoding, key: "shouldDoNotif")
                    
                }
                
                if(item.identifier == "PAM"){
                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "pamFileExists")
                }
                
                
            }
            
            self?.dismiss(animated: true, completion: {
                
                if(item.identifier == "notification_date"){
                    self!.pamAssessmentItem = AppDelegate.loadScheduleItem(filename:"pam")
                    self?.launchActivity(forItem: (self?.pamAssessmentItem)!)
                    
                }
                
        
                if(item.identifier == "PAM"){
                    self?.store.setValueInState(value: false as NSSecureCoding, forKey: "shouldDoSpot")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateInitialViewController()
                    appDelegate.transition(toRootViewController: vc!, animated: true)
                }
                
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
        
        delegate.store.setValueInState(value: String(describing:hour!) as NSSecureCoding, forKey: "notificationHour")
        delegate.store.setValueInState(value: String(describing:minutes!) as NSSecureCoding, forKey: "notificationMinutes")
        
        
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
