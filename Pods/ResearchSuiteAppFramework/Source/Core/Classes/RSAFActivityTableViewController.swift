//
//  RSAFActivityTableViewController.swift
//  Pods
//
//  Created by James Kizer on 3/28/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import ReSwift
import ResearchKit

open class RSAFActivityTableViewController: UITableViewController {

    open var schedule: RSAFSchedule?
    open var scheduleItems: [RSAFScheduleItem] = []
    open var store: Store<RSAFCombinedState>?
    open var taskBuilder: RSTBTaskBuilder?
    open var resultsDispatchableFunc: ((UUID, RSAFActivityRun, ORKTaskResult?) -> Dispatchable<RSAFCombinedState>?)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let schedule = schedule {
            self.scheduleItems = schedule.items
        }
        
    }
    
    fileprivate func scheduleItem(forIndexPath indexPath: IndexPath) -> RSAFScheduleItem? {
        return self.scheduleItems[(indexPath as NSIndexPath).row]
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleItems.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "ActivityCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let activityCell = cell as? RSAFActivityTableViewCell,
            let item = self.scheduleItem(forIndexPath: indexPath) else {
                return cell
        }
        
        activityCell.titleLabel.text = item.title
        activityCell.complete = false
        activityCell.timeLabel?.text = nil
        activityCell.subtitleLabel.text = nil
        
        return activityCell
        
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let taskBuilder = self.taskBuilder,
            let item = self.scheduleItem(forIndexPath: indexPath) else {
            return
        }
        
        if let dispatchableFunc = self.resultsDispatchableFunc {
            item.onCompletionActionCreators = [dispatchableFunc]
        }
        
        let action = RSAFActionCreators.queueActivity(fromScheduleItem: item, taskBuilder: taskBuilder)
        self.store?.dispatch(action)
        
    }

}
