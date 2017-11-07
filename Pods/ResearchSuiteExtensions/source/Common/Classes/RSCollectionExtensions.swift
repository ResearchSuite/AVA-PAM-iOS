//
//  RSCollectionExtensions.swift
//  Pods
//
//  Created by James Kizer on 7/11/17.
//
//

import UIKit

public extension Array {
    
    public func random() -> Element? {
        if self.count == 0 {
            return nil
        }
        else{
            let index = Int(arc4random_uniform(UInt32(self.count)))
            print(index)
            return self[index]
        }
    }
}

public extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    public mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

public extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    public func shuffled(shouldShuffle: Bool = true) -> [Iterator.Element] {
        if shouldShuffle {
            var result = Array(self)
            result.shuffle()
            return result
        }
        else {
            return Array(self)
        }
        
    }
}
