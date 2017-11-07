//
//  RSSliderView.swift
//  Pods
//
//  Created by James Kizer on 8/3/17.
//
//

import UIKit

open class RSSliderView: UIView {
    
    open class func newView(minimumValue: Int, maximumValue: Int) -> RSSliderView? {
        let bundle = Bundle(for: RSSliderView.self)
        guard let views = bundle.loadNibNamed("RSSliderView", owner: nil, options: nil),
            let view = views.first as? RSSliderView else {
                return nil
        }
        
        self.configureView(view: view, minimumValue: minimumValue, maximumValue: maximumValue)
        
        return view
    }
    
    open class func configureView(view: RSSliderView, minimumValue: Int, maximumValue: Int) {
        
        view.sliderView.numberOfSteps = maximumValue - minimumValue
        view.sliderView.maximumValue = Float(maximumValue)
        view.sliderView.minimumValue = Float(minimumValue)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(sliderTouched(_:)))
        view.sliderView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: view, action: #selector(sliderTouched(_:)))
        view.sliderView.addGestureRecognizer(panGestureRecognizer)
        
//        view.sliderView.isUserInteractionEnabled = false
        
        view.minimumValue = minimumValue
        view.maximumValue = maximumValue
    }

    public typealias OnValueChanged = (Int) -> Void
    public var onValueChanged: OnValueChanged?
    
    @IBOutlet public weak var maxValueLabel: UILabel!
    @IBOutlet public weak var minValueLabel: UILabel!
    @IBOutlet weak var sliderView: RSSlider!
    @IBOutlet public weak var minValueDescriptionLabel: UILabel!
    @IBOutlet public weak var neutralValueDescriptionLabel: UILabel!
    @IBOutlet public weak var maxValueDescriptionLabel: UILabel!
    @IBOutlet public weak var currentValueLabel: UILabel!
    
    open var minimumValue: Int!
    open var maximumValue: Int!
    
    func valueForTouch(_ gestureRecognizer: UIGestureRecognizer) -> Int? {

        //convert touch to slider
        let touchPoint = gestureRecognizer.location(in: self.sliderView)
        
        //compute value at touch
        let padding = self.sliderView.thumbRect(forBounds: self.sliderView.bounds, trackRect: self.sliderView.trackRect(forBounds: self.sliderView.bounds), value: 0.0).size.width / 2.0
        
        let trackRect = self.sliderView.trackRect(forBounds: self.sliderView.bounds)
        if touchPoint.x < (trackRect.minX - padding) || touchPoint.x > (trackRect.maxX + padding) {
            return nil
        }
        
        //normalize to [0,1]
        let position: Float = Float((touchPoint.x - trackRect.minX) / trackRect.width)
        let value: Float = position * Float(self.maximumValue - self.minimumValue) + Float(self.minimumValue)
        let roundedValue: Int = Int(round(value))
        
        return roundedValue
    }
    
    func sliderTouched(_ gestureRecognizer: UIGestureRecognizer) {
        print(gestureRecognizer)
        
        guard let value = self.valueForTouch(gestureRecognizer) else {
            return
        }
        
        //set value
        self.internalSetValue(value: value, animated: true)
        
        //notify
//        self.onValueChanged?(value)
        
        self.sliderView.sendActions(for: .valueChanged)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let roundedValue: Int = Int(round(sender.value))
        
        //set value
//        self.internalSetValue(value: roundedValue, animated: true)
        
        //notify
        self.onValueChanged?(roundedValue)
        
    }
    private func internalSetValue(value: Int, animated: Bool) {
        if value >= self.minimumValue &&
            value <= self.maximumValue {
            
            //this fixes case of +0
//            self.currentValueLabel.text = self.numberFormatter.string(from: NSNumber(integerLiteral: value))
            self.sliderView.showThumb = true
            //            self.sliderView.setThumbImage(self.savedThumbImage, for: .normal)
            self.sliderView.setValue(Float(value), animated: animated)
            self.sliderView.setNeedsLayout()
        }
        else {
            //            self.sliderView.setThumbImage(nil, for: .normal)
            self.sliderView.showThumb = false
            self.currentValueLabel.text = ""
            self.sliderView.setNeedsLayout()
        }
    }
    
    public func setValue(value: Int, animated: Bool) {
        self.internalSetValue(value: value, animated: animated)
        self.onValueChanged?(value)
    }

}
