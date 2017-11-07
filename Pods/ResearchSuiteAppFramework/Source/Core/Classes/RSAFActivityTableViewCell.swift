//
//  RSAFActivityTableViewCell.swift
//  Pods
//
//  Created by James Kizer on 3/28/17.
//
//

import UIKit

open class RSAFActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var uncheckedView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel?
    
    var complete: Bool = false {
        didSet {
            self.uncheckedView.isHidden = complete
            self.checkmarkImageView.isHidden = !complete
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.uncheckedView.layer.borderColor = UIColor.lightGray.cgColor
        self.uncheckedView.layer.borderWidth = 1
        self.uncheckedView.layer.cornerRadius = self.uncheckedView.bounds.size.height / 2
        
        self.timeLabel?.textColor = self.tintColor
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        self.timeLabel?.textColor = self.tintColor
    }

}
