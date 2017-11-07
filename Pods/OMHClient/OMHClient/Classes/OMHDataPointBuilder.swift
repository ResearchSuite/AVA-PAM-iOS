//
//  OMHDataPointBuilder.swift
//  Pods
//
//  Created by James Kizer on 1/13/17.
//
//

public class OMHSchema {
    let name: String
    let version: String
    let namespace: String
    
    public init(name: String, version: String, namespace: String) {
        self.name = name
        self.version = version
        self.namespace = namespace
    }
}

public enum OMHAcquisitionProvenanceModality: String {
    case Sensed = "sensed"
    case SelfReported = "self-reported"
}

public class OMHAcquisitionProvenance {
    let sourceName: String
    let sourceCreationDateTime: Date?
    let modality: OMHAcquisitionProvenanceModality?
    public init(sourceName: String, sourceCreationDateTime: Date?, modality: OMHAcquisitionProvenanceModality?) {
        self.sourceName = sourceName
        self.sourceCreationDateTime = sourceCreationDateTime
        self.modality = modality
    }
    
    public func toDict() -> [String: String]?  {
        
        var dict = ["source_name": sourceName]
        if let creationDateTime = self.sourceCreationDateTime {
            dict["source_creation_date_time"] = staticISO8601Formatter.string(from: creationDateTime)
        }
        if let modality = self.modality {
            dict["modality"] = modality.rawValue
        }
        return dict
        
    }
    
}

public protocol OMHDataPointBuilder: OMHDataPoint {
    var dataPointID: String { get }
    var creationDateTime: Date { get }
    var schema: OMHSchema { get }
    
    //header
    var header: [String: Any] { get }
    
    var acquisitionSourceName: String? { get }
    var acquisitionSourceCreationDateTime: Date? { get }
    var acquisitionModality: OMHAcquisitionProvenanceModality? { get }
    var acquisitionProvenance: OMHAcquisitionProvenance? { get }
    
    var body: [String: Any] { get }
}

public extension OMHDataPointBuilder {
    
    open func toDict() -> OMHDataPointDictionary {
        return [
            "header": self.header,
            "body": self.body
        ]
    }
    
    open var schemaDict: [String: String] {
        return [
            "namespace": self.schema.namespace,
            "name": self.schema.name,
            "version": self.schema.version
        ]
    }
    
    open var header: [String: Any] {
        
        var dict: [String: Any] = [
            "id": self.dataPointID,
            "creation_date_time": self.stringFromDate(self.creationDateTime),
            "schema_id": self.schemaDict
        ]
        
        if let acquisitionProvenanceDict = self.acquisitionProvenanceDict {
            dict["acquisition_provenance"] = acquisitionProvenanceDict
        }
        return dict
    }
    
    open var acquisitionProvenanceDict: [String: String]? {
        if let sourceName = self.acquisitionSourceName {
            var dict = ["source_name": sourceName]
            if let creationDateTime = self.acquisitionSourceCreationDateTime {
                dict["source_creation_date_time"] = self.stringFromDate(creationDateTime)
            }
            if let modality = self.acquisitionModality {
                dict["modality"] = modality.rawValue
            }
            return dict
        }
        else { return nil }
        
    }
    
    open var acquisitionProvenance: OMHAcquisitionProvenance? {
        if let sourceName = self.acquisitionSourceName {
            return OMHAcquisitionProvenance(
                sourceName: sourceName, sourceCreationDateTime:
                self.acquisitionSourceCreationDateTime,
                modality: self.acquisitionModality)
        }
        else { return nil }
    }
}
