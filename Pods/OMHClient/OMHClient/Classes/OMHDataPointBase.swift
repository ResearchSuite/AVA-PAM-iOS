//
//  OMHDataPointBase.swift
//  Pods
//
//  Created by James Kizer on 1/7/17.
//
//

open class OMHDataPointBase: NSObject, OMHDataPointBuilder {
    
    open var creationDateTime: Date = Date()
    open var dataPointID: String = UUID().uuidString
    
    open var acquisitionModality: OMHAcquisitionProvenanceModality?
    open var acquisitionSourceCreationDateTime: Date?
    open var acquisitionSourceName: String?
    
    open var schema: OMHSchema {
        fatalError("Not Implemented")
    }
    
    open var body: [String: Any] {
        fatalError("Not Implemented")
    }

    public required override init() {
        
    }
    
    public init(dataPointID: String, creationDateTime: Date) {
        self.creationDateTime = creationDateTime
        self.dataPointID = dataPointID
    }
    
//    public required init?(coder aDecoder: NSCoder) {
//        //coder.decodeObject(of: NSString.self, forKey: CoderKeys.code) as String?
//        guard let creationDateTime = aDecoder.decodeObject(of: NSDate.self, forKey: "creationDateTime") as? Date,
//            let dataPointID = aDecoder.decodeObject(of: NSString.self, forKey: "datapointID") as String? else {
//                return nil
//        }
//        
//        self.creationDateTime = creationDateTime
//        self.dataPointID = dataPointID
//        
//        if let rawModality = aDecoder.decodeObject(of: NSString.self, forKey: "aquiredModality") as String? {
//            self.acquisitionModality = OMHAcquisitionProvenanceModality(rawValue: rawModality)
//        }
//        
//        self.acquisitionSourceCreationDateTime = aDecoder.decodeObject(of: NSDate.self, forKey: "acquiredTime") as? Date
//        self.acquisitionSourceName = aDecoder.decodeObject(of: NSString.self, forKey: "acquiredName") as? String
//        
//    }
//    
//    open func encode(with aCoder: NSCoder) {
//        
//        aCoder.encode(self.creationDateTime, forKey: "creationDateTime")
//        aCoder.encode(self.dataPointID, forKey: "datapointID")
//        
//        aCoder.encode(self.acquisitionModality?.rawValue, forKey: "aquiredModality")
//        aCoder.encode(self.acquisitionSourceCreationDateTime, forKey: "acquiredTime")
//        aCoder.encode(self.acquisitionSourceName, forKey: "acquiredName")
//        
//    }
}
