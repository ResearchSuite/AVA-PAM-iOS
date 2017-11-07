//
//  RSQuestionViewController.swift
//  Pods
//
//  Created by James Kizer on 4/16/17.
//
//

import UIKit
import ResearchKit

open class RSQuestionViewController: ORKStepViewController {
    
    static let footerHeightWithoutContinueButton: CGFloat = 61.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet weak var continueButton: RSBorderedButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var footerHeight: NSLayoutConstraint!
    
    var _appeared: Bool = false
    open var hasAppeared: Bool {
        return _appeared
    }
    
    open var skipped: Bool = false
    private var _initializedResult: ORKResult?
    public var initializedResult: ORKResult? {
        return _initializedResult
    }
    
    open class var showsContinueButton: Bool {
        return true
    }
    
    open var continueButtonEnabled: Bool = true {
        didSet {
            self.continueButton.isEnabled = continueButtonEnabled
        }
    }

    override convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    override convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionViewController.self)
        self.init(nibName: "RSQuestionViewController", bundle: framework)
        self.step = step
        self._initializedResult = result
        self.restorationIdentifier = step!.identifier
        
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.text = self.step?.title
        self.textLabel.text = self.step?.text
        
        if let step = self.step as? RSStep {
            if let attributedTitle = step.attributedTitle {
                self.titleLabel.attributedText = attributedTitle
            }
            
            if let attributedText = step.attributedText {
                self.textLabel.attributedText = attributedText
            }
        }
        
        
        
        if self.hasNextStep() {
            self.setContinueButtonTitle(title: "Next")
        }
        else {
            self.setContinueButtonTitle(title: "Done")
        }
        
        if !type(of: self).showsContinueButton {
            self.footerHeight.constant = RSQuestionViewController.footerHeightWithoutContinueButton
        }
        
        if let step = self.step {
            self.skipButton.isHidden = !step.isOptional
        }
        
    }
    
    //this is due to bug in RK 1.4.1. Parent result date not initialized properly
    //sub classes should check hasAppeared before accessing
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._appeared = true
    }
    
    open func setSkipButtonTitle(title: String) {
        self.skipButton.setTitle(title, for: .normal)
    }
    
    open func setContinueButtonTitle(title: String) {
        self.continueButton.setTitle(title, for: .normal)
    }
    
    open func notifyDelegateAndMoveForward() {
        if let delegate = self.delegate {
            delegate.stepViewControllerResultDidChange(self)
        }
        self.goForward()
    }
    
    open func validate() -> Bool {
        return true
    }
    
    open func clearAnswer() {
        self.skipped = true
    }
    
    @IBAction open func continueTapped(_ sender: Any) {
        if self.validate() {
            self.notifyDelegateAndMoveForward()
        }
    }
    
    @IBAction open func skipTapped(_ sender: Any) {
        self.clearAnswer()
        self.notifyDelegateAndMoveForward()
    }
}
