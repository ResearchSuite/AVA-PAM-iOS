//
//  RSTBServiceLoader.swift
//  Pods
//
//  Created by James Kizer on 1/9/17.
//
//

import UIKit

class RSTBServiceLoader<Proto> {
    fileprivate var serviceProviders: [Proto]! = []
    
    open func addService<T>(service: T) {
        if let protoService = service as? Proto {
            self.serviceProviders = self.serviceProviders + [protoService]
        }
        
    }
    
    open func iterator() -> IndexingIterator<Array<Proto>> {
        return self.serviceProviders.makeIterator()
    }
}
