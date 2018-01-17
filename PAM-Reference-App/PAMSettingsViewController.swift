//
//  SettingsViewController.swift
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
import MessageUI
import ResearchSuiteResultsProcessor
import sdlrkx

class PAMSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var backButton: UIBarButtonItem!
    var store: RSStore!
    
    @IBOutlet
    var tableView: UITableView!
    
    var items: [String] = ["Take PAM Assessment","Set Notification Time","Email PAM Assessment Data"]
    var pamItem: RSAFScheduleItem!
    var notificationItem: RSAFScheduleItem!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.store = RSStore()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedCell = tableView.cellForRow(at: indexPath)!
        deselectedCell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let notificationHour = self.store.valueInState(forKey: "notificationHour") as! String
        let notificationMinutes = self.store.valueInState(forKey: "notificationMinutes") as! String
        
        var convertedTime:[String]! = []
        
        convertedTime = self.hourConversion(hour: notificationHour,minute: notificationMinutes)
        
        let notificationString = self.items[1] + ":      " + convertedTime[0] + ":" + convertedTime[2] + " " + convertedTime[1]

        
        if(indexPath.row == 1) {
            cell.textLabel?.text = notificationString
        }
        else {
            
            cell.textLabel?.text = self.items[indexPath.row]
        }
        
        cell.textLabel?.textColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1.0)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60.0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.launchPAMAssessment()
        }
        
        if indexPath.row == 1 {
            self.setNotification()
        }
        
        if indexPath.row == 2 {
            
            let shouldSendEmail = self.store.valueInState(forKey: "pamFileExists") as! Bool
            if(shouldSendEmail){
                self.sendEmail()
            }
            else {
                let sendMailErrorAlert = UIAlertView(title: "No PAM Assessment Saved", message: "Please retake a PAM Assessment", delegate: self, cancelButtonTitle: "OK")
                sendMailErrorAlert.show()
            }
           
        }
        
    
    }
    
    func launchPAMAssessment() {
        self.pamItem = AppDelegate.loadScheduleItem(filename: "pam")
        self.launchActivity(forItem: pamItem)
    }
    
    
    
    func setNotification() {
        self.notificationItem = AppDelegate.loadScheduleItem(filename: "notification")
        self.launchActivity(forItem: notificationItem)
    }
    
    func sendEmail() {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        
    }
    
    func deleteFile() {
        delegate.CSVBackend.removeFileForType(type: CTFPAMRaw.self)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if(result == MFMailComposeResult.sent){
            self.deleteFile()
            self.store.setValueInState(value: false as NSSecureCoding, forKey: "pamFileExists")
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("PAM Data")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        
        let attach = delegate.CSVBackend.getFileURLForType(typeIdentifier: "PAM")
        
        do {
            
            if FileManager.default.fileExists(atPath: (attach?.path)!){
                let cert = try NSData(contentsOfFile: (attach?.path)!)  as Data
                
                mailComposerVC.addAttachmentData(cert as Data, mimeType: "text/csv", fileName: "PAM.csv")
                
                return mailComposerVC
                
            }
        } catch {
            print(error)
        }
        
        
        return mailComposerVC
    }

    
    func signOut() {
        
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
                    DispatchQueue.main.async{
                        self?.tableView.reloadData()
                    }
                }
                
                if(item.identifier == "PAM"){
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

    
    func hourConversion (hour: String, minute: String) -> [String] {
        
        var newHour: String!
        var newMinute: String!
        var am_pm: String!
        
        var minuteInt: Int = Int(minute)!
        if minuteInt < 10 {
            newMinute = "0" + minute
        }
        else {
            newMinute = minute
        }
        
        switch hour{
        case "00":
            newHour = "12"
            am_pm = "am"
        case "12":
            newHour = "12"
            am_pm = "pm"
        case "13":
            newHour = "1"
            am_pm = "pm"
        case "14":
            newHour = "2"
            am_pm = "pm"
        case "15":
            newHour = "3"
            am_pm = "pm"
        case "16":
            newHour = "4"
            am_pm = "pm"
        case "17":
            newHour = "5"
            am_pm = "pm"
        case "18":
            newHour = "6"
            am_pm = "pm"
        case "19":
            newHour = "7"
            am_pm = "pm"
        case "20":
            newHour = "8"
            am_pm = "pm"
        case "21":
            newHour = "9"
            am_pm = "pm"
        case "22":
            newHour = "10"
            am_pm = "pm"
        case "23":
            newHour = "11"
            am_pm = "pm"
        default:
            newHour = hour
            am_pm = "am"
        }
        
        
        return [newHour,am_pm,newMinute]
        
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
