////
////  PAMRaw+CSVEncodable.swift
////  PAM-Reference-App
////
////  Created by Christina Tsangouri on 1/5/17.
////  Copyright © 2017 Christina Tsangouri. All rights reserved.
////

import Foundation
import Gloss
import sdlrkx
import ResearchSuiteResultsProcessor

extension CTFPAMRaw: CSVEncodable {
    
    
   open static var typeString: String {
   
        let pamIdentifier = "PAM"
        return pamIdentifier
    
    }
    
    open static var header: String {
        
        let pamHeader = ["timestamp","affect_arousal","mood","negative_affect","positive_affect","image","affect_valence"]
        
        let header = pamHeader.joined(separator:",")

        return header
    }
    
    open func toRecords() -> [CSVRecord] {
        
        let time = self.stringFromDate(self.creationDateTime)
        
        let flatRecord = (self.pamChoice.flatMap({ (key, value) -> String in
            return "\(value)"
        }) as Array).joined(separator: ",")
        
        let completeRecord = time + "," + flatRecord
        
        return [completeRecord]
    }
    
}
