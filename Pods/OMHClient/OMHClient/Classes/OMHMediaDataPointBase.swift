//
//  OMHMediaDataPointBase.swift
//  Pods
//
//  Created by James Kizer on 1/13/17.
//
//

import UIKit

open class OMHMediaDataPointBase: OMHDataPointBase, OMHMediaDataPoint {
    
    private var _attachments: [OMHMediaAttachment]! = []
    
    public var attachments: [OMHMediaAttachment] {
        return self._attachments
    }
    
    public func addAttachment(attachment: OMHMediaAttachment) {
        if !self._attachments.contains(where: {$0.fileName == attachment.fileName}) {
            self._attachments = self._attachments + [attachment]
//            return true
        }
        else {
//            return false
        }
    }
}
