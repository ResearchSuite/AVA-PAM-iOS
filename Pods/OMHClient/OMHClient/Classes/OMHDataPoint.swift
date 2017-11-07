//
//  OMHDataPoint.swift
//  Pods
//
//  Created by James Kizer on 1/7/17.
//
//

let staticISO8601Formatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPOSIXLocale as Locale!
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

public typealias OMHDataPointDictionary = [String: Any]

public protocol OMHDataPoint {
    func toDict() -> OMHDataPointDictionary
}

public extension OMHDataPoint {
    public static func ISO8601Formatter() -> DateFormatter {
        return staticISO8601Formatter
    }
    
    public func stringFromDate(_ date: Date) -> String {
        return Self.ISO8601Formatter().string(from: date)
    }
    
    public func dateFromString(_ string: String) -> Date? {
        return Self.ISO8601Formatter().date(from: string)
    }
    
}
