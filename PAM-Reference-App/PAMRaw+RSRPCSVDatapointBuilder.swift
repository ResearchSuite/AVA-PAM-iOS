////
////  PAMRaw+RSRPCSVDatapointBuilder.swift
////  PAM-Reference-App
////
////  Created by Christina Tsangouri on 11/28/17.
////  Copyright © 2017 Christina Tsangouri. All rights reserved.
////
//
////
////  YADLFullRaw+RSRPCSVDatapoint.swift
////  YADL Reference App
////
////  Created by Christina Tsangouri on 11/14/17.
////  Copyright © 2017 Christina Tsangouri. All rights reserved.
////
//
//import Foundation
//import Gloss
//import sdlrkx
//import ResearchSuiteResultsProcessor
//
//extension CTFPAMRaw: RSRPCSVDatapointBuilder {
//    
//    open var identifier: String {
//        return self.taskIdentifier
//    }
//    
//    open var dataPointID: String {
//        return self.uuid.uuidString
//    }
//    
//    open var creationDateTime: Date {
//        return self.startDate ?? Date()
//    }
//    
//    open var headerDict: String {
//        
//        var dict: [String:Any] = [
//            "id": self.dataPointID,
//            "creation_date_time": self.stringFromDate(self.creationDateTime),
//            "schema_id": self.schemaDict,
//            "taskIdentifier": self.taskIdentifier,
//            "taskRunUUID": self.taskRunUUID.uuidString
//        ]
//        
//        let header = (self.pamChoice.flatMap({ (key, value) -> String in
//                return "\(key)"
//            }) as Array).joined(separator: ",")
//        
//        
//        let completeHeader = "timestamp," + header
//        
//        return completeHeader
//        
//    }
//    
//    
//    
//    
//    open var header: String {
//        
//        return self.headerDict
//    }
//    
//    open var records: [String] {
//        
//        let time = self.stringFromDate(self.creationDateTime)
//        
//        let flatRecord = (self.pamChoice.flatMap({ (key, value) -> String in
//            return "\(value)"
//        }) as Array).joined(separator: ",")
//        
//        let completeRecord = time + "," + flatRecord
//
//        
//        
//        return [completeRecord]
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
