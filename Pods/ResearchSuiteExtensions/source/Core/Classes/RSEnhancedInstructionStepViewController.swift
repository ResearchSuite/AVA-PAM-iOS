//
//  RSEnhancedInstructionStepViewController.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit

open class RSEnhancedInstructionStepViewController: RSQuestionViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let step = self.step as? RSEnhancedInstructionStep else {
            return
        }
        
        if let attributedTitle = step.attributedTitle {
            self.titleLabel.attributedText = attributedTitle
        }
        
        if let attributedText = step.attributedText {
            self.textLabel.attributedText = attributedText
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
