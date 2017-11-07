//
//  OMHMediaDataPoint.swift
//  Pods
//
//  Created by James Kizer on 1/13/17.
//
//

public protocol OMHMediaDataPoint: OMHDataPoint {
    var attachments: [OMHMediaAttachment] { get }
}
