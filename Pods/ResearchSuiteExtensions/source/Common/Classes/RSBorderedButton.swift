//
//  RSBorderedButton.swift
//  Pods
//
//  Created by James Kizer on 7/11/17.
//
//

import UIKit

open class RSBorderedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
    
    private func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: UIControlState.normal)
        self.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        self.setTitleColor(UIColor.white, for: UIControlState.selected)
        self.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: UIControlState.disabled)
    }
    
    var configuredColor: UIColor? {
        didSet {
            if let color = self.configuredColor {
                self.setTitleColor(color)
            }
            else {
                self.setTitleColor(self.tintColor)
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let color = self.titleColor(for: self.state) {
            self.layer.borderColor = color.cgColor
        }
        
        
    }
    
    override open func tintColorDidChange() {
        //if we have not configured the color, set
        super.tintColorDidChange()
        if let _ = self.configuredColor {
            return
        }
        else {
            self.setTitleColor(self.tintColor)
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + 20.0, height: superSize.height)
    }

}
