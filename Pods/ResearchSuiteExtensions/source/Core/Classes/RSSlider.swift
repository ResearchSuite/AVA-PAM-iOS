//
//  RSSlider.swift
//  Pods
//
//  Created by James Kizer on 8/3/17.
//
//

import UIKit

open class RSSlider: UISlider {
    
    static let LineWidth: CGFloat = 1.0
    static let LineHeight: CGFloat = 8.0
    
    func centerXForValue(value: Int, trackRect: CGRect) -> CGFloat? {
        
        guard let numberOfSteps = self.numberOfSteps else {
            return nil
        }
        
        let discreteOffset = Int(round(Float(value) - self.minimumValue))
        
        var x: CGFloat = trackRect.origin.x + (trackRect.size.width - RSSlider.LineWidth) * CGFloat(discreteOffset) / CGFloat(numberOfSteps)
        
        x = x + (RSSlider.LineWidth / 2)
        
        return x
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        let bounds = self.bounds
        let trackRect = self.trackRect(forBounds: bounds)
        
        let centerY = bounds.size.height / 2.0
        
        UIColor.black.set()
        
        let path = UIBezierPath()
        path.lineWidth = RSSlider.LineWidth
        
        let minimumValue = Int(round(self.minimumValue))
        let maximumValue = Int(round(self.maximumValue))
        
        (minimumValue...maximumValue).forEach { (value) in
            
            if let centerX = self.centerXForValue(value: value, trackRect: trackRect) {
                path.move(to: CGPoint(x: centerX, y: centerY - RSSlider.LineHeight))
                path.addLine(to: CGPoint(x: centerX, y: centerY + RSSlider.LineHeight))
            }
            
        }
        
        path.stroke()
        
        UIBezierPath.init(rect: trackRect).fill()
    }
    
    open var showThumb = false
    open var numberOfSteps: Int?
    
    open override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        
        var thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        if !self.showThumb {
            thumbRect.origin.x = 1000
        }
        else {
            if let centerX = self.centerXForValue(value: Int(round(value)), trackRect: rect) {
                thumbRect.origin.x = centerX - (thumbRect.size.width / 2.0)
            }
            
        }
        
        return thumbRect
    }
    
}
