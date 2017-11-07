//
//  ORBEIntermediateDatapointTransformer.swift
//  Pods
//
//  Created by James Kizer on 2/10/17.
//
//

import UIKit
import ResearchSuiteResultsProcessor
import OMHClient

public protocol ORBEIntermediateDatapointTransformer {
    static func transform(intermediateResult: RSRPIntermediateResult) -> OMHDataPoint?
}
